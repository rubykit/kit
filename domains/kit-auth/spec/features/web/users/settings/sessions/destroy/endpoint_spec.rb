require_relative '../../../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|settings|sessions|destroy', type: :feature do

  let(:user) { create(:user) }

  let(:post_action_route_id)  { 'web|settings|sessions|destroy|after' }
  let(:post_action_route_url) { route_id_to_path(id: post_action_route_id) }

  let(:first_access_token) { user.user_secrets.order(created_at: :asc).where(category: :access_token).first }
  let(:second_access_token) do
    Kit::Auth::Actions::AccessTokens::CreateForSignIn
      .call(
        user:        user,
        application: Kit::Auth::Actions::Applications::LoadWeb.call[1][:application],
      )[1][:access_token]
  end

  before do
    web_sign_in(user: current_user)

  end

  context 'when the current user is the owner' do

    before do
      expect(second_access_token.id).not_to eq first_access_token.id
    end

    let(:current_user) { user }

    it 'revokes the session on the correct route' do
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|users|auth|access_token|revoked', params: hash_including(user_id: user.id, user_secret_id: second_access_token.id)))

      visit_route_id(id: 'web|settings|sessions|destroy', params: { user_secret_id: second_access_token.id })

      # Redirect to the correct post action route route
      assert_current_path post_action_route_url
      expect(page).to have_content post_action_route_id

      # Display the expected notification
      flash_text = I18n.t('kit.auth.notifications.sign_out.devices.success', email: user.email)
      expect(page.body.include?(flash_text)).to be true

      # Access token has been revoked
      second_access_token.reload
      expect(second_access_token.revoked?).to be true
    end

  end

  context 'when the current user is not the owner' do

    let(:current_user) { create(:user) }

    let(:post_action_route_id)  { 'web|errors|forbidden' }

    it 'redirects' do
      visit_route_id(id: 'web|settings|sessions|destroy', params: { user_secret_id: second_access_token.id })

      # Redirect to the correct post action route route
      assert_current_path post_action_route_url
      expect(page).to have_content post_action_route_id

      # Display the expected notification
      flash_text = I18n.t('kit.auth.notifications.errors.forbidden')
      expect(page.body.include?(flash_text)).to be true

      # Access token has NOT been revoked
      second_access_token.reload
      expect(second_access_token.revoked?).to be false
    end

  end

end
