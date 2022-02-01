require_relative '../../../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|settings|oauth|destroy', type: :feature do

  let(:user) { create(:user) }

  let(:post_action_route_id)  { 'web|settings|oauth|destroy|after' }
  let(:post_action_route_url) { route_id_to_path(id: post_action_route_id) }

  let(:first_user_oauth_identity)  { create(:user_oauth_identity, user: user, provider: :facebook) }
  let(:second_user_oauth_identity) { create(:user_oauth_identity, user: user, provider: :facebook) }

  before do
    web_sign_in(user: current_user)

    expect(first_user_oauth_identity.id).not_to eq second_user_oauth_identity.id
  end

  context 'when the current user is the owner' do

    let(:current_user) { user }

    it 'revokes the session on the correct route' do
      # Calls the correct event endpoint
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|users|oauth|unlinked', params: hash_including(
          user_id:                second_user_oauth_identity.user_id,
          user_oauth_identity_id: second_user_oauth_identity.id,
          provider:               second_user_oauth_identity.provider,
          provider_uid:           second_user_oauth_identity.provider_uid,
        )
      ))

      visit_route_id(id: 'web|settings|oauth|destroy', params: { user_oauth_identity_id: second_user_oauth_identity.id })

      # Redirect to the correct post action route route
      assert_current_path post_action_route_url
      expect(page).to have_content post_action_route_id

      # Display the expected notification
      flash_text = I18n.t('kit.auth.notifications.oauth.unlink.success', provider: second_user_oauth_identity.provider)
      expect(page.body.include?(flash_text)).to be true

      # UserOauthIdentity has been deleted
      second_user_oauth_identity.reload
      expect(second_user_oauth_identity.deleted?).to be true
    end

  end

  context 'when the current user is not the owner' do

    let(:current_user) { create(:user) }

    let(:post_action_route_id)  { 'web|errors|forbidden' }

    it 'redirects' do
      visit_route_id(id: 'web|settings|oauth|destroy', params: { user_oauth_identity_id: second_user_oauth_identity.id })

      # Redirect to the correct post action route route
      assert_current_path post_action_route_url
      expect(page).to have_content post_action_route_id

      # Display the expected notification
      flash_text = I18n.t('kit.auth.notifications.errors.forbidden')
      expect(page.body.include?(flash_text)).to be true

      # UserOauthIdentity has NOT been deleted
      second_user_oauth_identity.reload
      expect(second_user_oauth_identity.deleted?).to be false
    end

  end

end
