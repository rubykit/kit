require_relative '../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|oauth|sign_in', type: :feature, js: true do
  let(:route_id)     { 'web|users|oauth|sign_in' }
  let(:route_params) { { provider: provider } }
  let(:start_route)  { route_id_to_path(id: route_id, params: route_params) }

  let(:email)    { 'user@rubykit.com' }
  let(:password) { 'Abcd12_xxxxxxxxx' }
  let(:user)     { create_user(email: email, password: password) }

  let(:provider)          { :facebook }
  let(:omniauth_strategy) { :facebook_web }

  let(:default_post_action_route) { route_id_to_path(id: 'web|users|sign_in|after') }
  let(:callback_route)            { route_id_to_path(id: 'web|users|oauth|callback', params: { provider: provider }) }

  before do
    expect(Kit::Auth::Models::Write::User.where(email: email).count).to eq 0

    OmniAuth.config.test_mode = true

    mock = omniauth_facebook_mock(
      omniauth_strategy: omniauth_strategy,
      email:             email,
    )

    OmniAuth.config.mock_auth[omniauth_strategy]  = mock
    Rails.application.env_config['omniauth.auth'] = mock

    Kit::Auth::Services::Oauth.providers.clear
    Kit::Auth::Services::Oauth.providers << {
      group:             :web,
      external_name:     :facebook,
      internal_name:     :facebook,
      omniauth_strategy: :facebook_web,
    }
  end

  after do
    Rails.application.env_config['omniauth.auth'] = nil
    OmniAuth.config.test_mode = false
  end

  shared_examples 'a successful sign-in' do
    it 'signs the user in' do
      # Calls the correct event endpoint
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|user|auth|sign_in', params: hash_including(user_id: user.id, sign_in_method: :oauth)))
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|user|oauth|associate', params: hash_including(user_oauth_identity_id: instance_of(Integer))))

      # Visit the page && fill the form
      visit start_route

      # Redirect to the correct post action route route
      assert_current_path post_action_route

      # User has been signed-in
      expect(page).to have_content I18n.t('kit.auth.pages.header.sign_out.action')

      # Display the expected notification
      flash_text = I18n.t('kit.auth.notifications.sign_in.success', email: email)
      expect(page.body.include?(flash_text)).to be true
    end
  end

  context 'with valid sign-in data' do
    let(:post_action_route) { default_post_action_route }

    it_behaves_like 'a successful sign-in'
  end

=begin
  # ERROR: there is some cookie issue with Capybara + Omniauth it seems (maybe redirect?). Cannot get the intent to be saved & sent back.
  context 'with sign in intent' do
    let(:intent_type)       { :spec_sign_in }
    let(:route_params)      { { provider: provider, intent: intent_type } }
    let(:post_action_route) { route_id_to_path(id: 'web|intent|post_sign_in') }

    before do
      Kit::Auth::Services::Intent.default_intent_store[:types][intent_type] = ->(router_conn:) { [:ok, redirect_url: post_action_route] }
      expect(post_action_route).not_to eq default_post_action_route
    end

    it_behaves_like 'a successful sign-in'
  end
=end

end
