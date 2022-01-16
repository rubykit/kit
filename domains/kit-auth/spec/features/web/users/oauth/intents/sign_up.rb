require_relative '../../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|oauth|sign_up', type: :feature do
  include_context 'omniauth'

  let(:provider)          { :facebook }
  let(:omniauth_strategy) { :facebook_web }

  let(:start_route_id)        { 'web|users|oauth|sign_up' }
  let(:start_route_params)    { { provider: provider, intent: intent_type } }
  let(:start_route_url)       { route_id_to_path(id: start_route_id, params: start_route_params) }

  let(:post_action_route_id)  { 'web|intent|post_sign_up' }
  let(:post_action_route_url) { route_id_to_path(id: post_action_route_id) }

  let(:intent_type) { :user_auth }

  let(:email) { 'user@rubykit.com' }

  before do
    expect(Kit::Auth::Models::Write::User.where(email: email).count).to eq 0

    Kit::Router::Adapters::Http::Intent::Store.default_intent_store[intent_type] = {
      get: ->(router_conn:, **)                { [:ok, intent_value: 'not_used_here_anyway'] },
      use: ->(router_conn:, intent_value:, **) { [:ok, redirect_url: post_action_route_url] },
    }
  end

  after do
    Kit::Router::Adapters::Http::Intent::Store.default_intent_store[intent_type] = nil
  end

  context 'with sign up intent' do

    it 'creates the user account' do
      # Calls the correct event endpoint
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|user|auth|sign_up', params: hash_including(user_id: instance_of(Integer), sign_up_method: :oauth)))
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|user|auth|sign_in', params: hash_including(user_id: instance_of(Integer), sign_in_method: :oauth)))
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|user|oauth|linked', params: hash_including(user_oauth_identity_id: instance_of(Integer))))

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
