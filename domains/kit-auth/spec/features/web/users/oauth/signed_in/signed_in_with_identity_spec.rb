require_relative '../../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|oauth|callback', type: :feature do
  include_context 'omniauth'

  let(:omniauth_provider) { :facebook }
  let(:omniauth_strategy) { :facebook_web }

  let(:start_route_id)        { 'web|users|oauth|callback' }
  let(:start_route_params)    { { provider: omniauth_provider } }
  let(:start_route_url)       { route_id_to_path(id: start_route_id, params: start_route_params) }

  let(:post_action_route_id)  { 'web|users|oauth|error|already_linked' }
  let(:post_action_route_url) { route_id_to_path(id: post_action_route_id) }

  let(:user)  { create(:user) }
  let(:email) { user.email }

  let(:omniauth_mock_data)  { omniauth_mock_data_facebook }
  let(:user_oauth_identity) { create(:user_oauth_identity, user: user, provider: omniauth_provider, provider_uid: omniauth_mock_data[:uid]) }

  before do
    user
    user_oauth_identity

    expect(user.user_oauth_identities.count).to eq 1

    sign_in_user_for_feature(user: user)
  end

  after do
    expect(user.user_oauth_identities.count).to eq 1
  end

  context 'with compatible provider data' do

    it 'redirect with a notification' do
      # Visit the page
      visit start_route_url

      # Redirect to the correct post action route route
      assert_current_path post_action_route_url
      expect(page).to have_content post_action_route_id

      # Display the expected notification
      flash_text = I18n.t('kit.auth.notifications.oauth.link.already_linked', provider: omniauth_provider)
      expect(page.body.include?(flash_text)).to be true
    end

  end

end
