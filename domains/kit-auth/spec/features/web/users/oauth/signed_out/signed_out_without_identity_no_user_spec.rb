require_relative '../../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|oauth|sign_up', type: :feature do
  include_context 'omniauth'

  let(:route_id)     { 'web|users|oauth|sign_up' }
  let(:route_params) { { provider: provider } }
  let(:start_route)  { route_id_to_path(id: route_id, params: route_params) }

  let(:email)    { 'user@rubykit.com' }

  let(:provider)          { :facebook }
  let(:omniauth_strategy) { :facebook_web }

  #let(:callback_route_url)    { route_id_to_path(id: 'web|users|oauth|callback', params: { provider: provider }) }

  let(:post_action_route_url) { route_id_to_path(id: post_action_route_id) }

  before do
    expect(Kit::Auth::Models::Write::User.where(email: email).count).to eq 0
  end

  shared_examples 'a successful sign-up' do
    it 'creates the user account' do
      # Calls the correct event endpoint
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|user|auth|sign_up', params: hash_including(user_id: instance_of(Integer), sign_up_method: :oauth)))
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|user|auth|sign_in', params: hash_including(user_id: instance_of(Integer), sign_in_method: :oauth)))
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|user|oauth|associate', params: hash_including(user_oauth_identity_id: instance_of(Integer))))

      # Visit the page
      visit start_route

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

  context 'with valid sign-up data' do
    let(:post_action_route_id) { 'web|users|oauth|sign_up|after' }

    it_behaves_like 'a successful sign-up'
  end

=begin
  # ERROR: there is some cookie issue with Capybara + Omniauth it seems (maybe redirect?). Cannot get the intent to be saved & sent back.
  context 'with sign up intent' do
    let(:intent_type)       { :spec_sign_up }
    let(:route_params)      { { provider: provider, intent: intent_type } }
    let(:post_action_route) { route_id_to_path(id: 'web|intent|post_sign_up') }

    before do
      Kit::Auth::Services::Intent.default_intent_store[:types][intent_type] = ->(router_conn:) { [:ok, redirect_url: post_action_route] }
      expect(post_action_route).not_to eq default_post_action_route
    end

    it_behaves_like 'a successful sign-up'
  end
=end

end
