require_relative '../../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|oauth|sign_in', type: :feature do
  include_context 'omniauth'

  let(:provider)          { :facebook }
  let(:omniauth_strategy) { :facebook_web }

  let(:start_route_id)        { 'web|users|oauth|sign_in' }
  let(:start_route_params)    { { provider: provider, intent: intent_type } }
  let(:start_route_url)       { route_id_to_path(id: start_route_id, params: start_route_params) }

  let(:post_action_route_id)  { 'web|intent|post_sign_in' }
  let(:post_action_route_url) { route_id_to_path(id: post_action_route_id) }

  let(:intent_type) { :spec_sign_in }

  let(:email)    { 'user@rubykit.com' }
  let(:password) { 'Abcd12_xxxxxxxxx' }
  let(:user)     { create(:user, email: email, password: password) }

  let(:user_oauth_identity) { create(:user_oauth_identity, user: user, provider: provider, provider_uid: omniauth_mock_data[:uid]) }

  before do
    user
    user_oauth_identity

    expect(Kit::Auth::Models::Write::User.where(email: email).count).to eq 1
    expect(user.user_oauth_identities.count).to eq 1

    Kit::Auth::Services::Intent.default_intent_store[:types][intent_type] = ->(router_conn:) { [:ok, redirect_url: post_action_route] }
  end

  after do
    expect(user.user_oauth_identities.count).to eq 1
  end

=begin
  # ERROR: there is some cookie issue with Capybara + Omniauth it seems (maybe redirect?). Cannot get the intent to be saved & sent back.
  context 'with sign in intent' do

    it 'signs the user in' do
      # Calls the correct event endpoint
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|user|auth|sign_in', params: hash_including(user_id: user.id, sign_in_method: :oauth)))

      # Visit the page
      visit start_route_url

      # Redirect to the correct post action route route
      assert_current_path post_action_route_url
      expect(page).to have_content post_action_route_id

      # User has been signed-in
      expect(page).to have_content I18n.t('kit.auth.pages.header.sign_out.action')

      # Display the expected notification
      flash_text = I18n.t('kit.auth.notifications.sign_in.success', email: email)
      expect(page.body.include?(flash_text)).to be true
    end

  end
=end

end
