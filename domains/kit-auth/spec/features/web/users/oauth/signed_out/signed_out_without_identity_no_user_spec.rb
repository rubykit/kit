require_relative '../../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|oauth|callback', type: :feature do
  include_context 'omniauth'

  let(:omniauth_provider)  { :facebook }
  let(:omniauth_strategy)  { :facebook_web }
  let(:omniauth_mock_data) { omniauth_mock_data_facebook }

  let(:start_route_id)        { 'web|users|oauth|callback' }
  let(:start_route_params)    { { provider: omniauth_provider } }
  let(:start_route_url)       { route_id_to_path(id: start_route_id, params: start_route_params) }

  let(:post_action_route_id)  { 'web|users|sign_up|oauth|after' }
  let(:post_action_route_url) { route_id_to_path(id: post_action_route_id) }

  let(:email) { 'user@rubykit.com' }

  before do
    expect(Kit::Auth::Models::Write::User.where(email: email).count).to eq 0
  end

  context 'with valid sign-up data' do

    it 'creates the user account' do
      # Calls the correct event endpoint
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|users|auth|sign_up', params: hash_including(user_id: instance_of(Integer), sign_up_method: :oauth)))
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|users|auth|sign_in', params: hash_including(user_id: instance_of(Integer), sign_in_method: :oauth)))
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|users|oauth|linked', params: hash_including(user_oauth_identity_id: instance_of(Integer))))

      # Visit the page
      visit start_route_url

      # Redirect to the correct post action route route
      assert_current_path post_action_route_url
      expect(page).to have_content post_action_route_id

      # User has been signed-in
      expect(page).to have_content I18n.t('kit.auth.pages.header.sign_out.action')

      # Display the expected notification
      flash_text = I18n.t('kit.auth.notifications.sign_up.success', email: email)
      expect(page.body.include?(flash_text)).to be true

      # Added a user in the db
      expect(Kit::Auth::Models::Write::User.where(email: email).count).to eq 1
    end

  end

end
