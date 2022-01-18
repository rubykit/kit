require_relative '../../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|oauth|callback', type: :feature do
  include_context 'omniauth'

  let(:omniauth_provider) { :facebook }
  let(:omniauth_strategy) { :facebook_web }

  let(:start_route_id)        { 'web|users|oauth|callback' }
  let(:start_route_params)    { { provider: omniauth_provider } }
  let(:start_route_url)       { route_id_to_path(id: start_route_id, params: start_route_params) }

  let(:post_action_route_id)  { 'web|users|oauth|error|users_oauth_identity_conflict' }
  let(:post_action_route_url) { route_id_to_path(id: post_action_route_id) }

  let(:user_session_email) { 'current_user@rubykit.org' }
  let(:user_other_email)   { 'other_user@rubykit.org' }

  let(:user_session) { create(:user, email: user_session_email) }
  let(:user_other)   { create(:user, email: user_other_email) }

  let(:omniauth_mock_data) do
    omniauth_facebook_mock(
      omniauth_strategy: omniauth_strategy,
      email:             user_other_email,
    )
  end

  let(:user_oauth_identity) { create(:user_oauth_identity, user: user_other, provider: omniauth_provider, provider_uid: omniauth_mock_data[:uid]) }

  before do
    user_session
    user_other
    user_oauth_identity

    expect(user_session.email).not_to eq user_other.email
    expect(user_session.id).not_to eq user_oauth_identity.user_id
    expect(user_session.user_oauth_identities.count).to eq 0

    sign_in_user_for_feature(user: user_session)
  end

  after do
    expect(user_session.user_oauth_identities.count).to eq 0
  end

  context 'with incompatible provider data email' do

    it 'redirect with a notification' do
      # Visit the page
      visit start_route_url

      # Redirect to the correct post action route route
      assert_current_path post_action_route_url
      expect(page).to have_content post_action_route_id

      # Display the expected notification
      i18n_params = {
        session_user_email:             user_session.email,
        provider:                       omniauth_provider,
        user_oauth_identity_user_email: user_other.email,
      }

      flash_text = I18n.t('kit.auth.notifications.oauth.errors.users_oauth_identity_conflict', **i18n_params)
      expect(page.body.include?(flash_text)).to be true
    end

  end

end
