require_relative '../../../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|settings|sessions', type: :feature do

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
    web_sign_in(user: user)

    expect(second_access_token.id).not_to eq first_access_token.id
  end

  it 'displays a link to end the session & revokes the access_token' do
    # Calls the correct event endpoint
    expect(Kit::Router::Services::Adapters).to receive(:cast)
      .with(hash_including(route_id: 'event|user|auth|access_token|revoked', params: hash_including(user_id: user.id, user_secret_id: second_access_token.id)))

    visit route_id_to_path(id: 'web|settings|sessions')

    expect(page).to have_selector('[data-type="session.device"]', count: 2)

    # Click the delete button
    find("[data-type='session.device'][data-session-id='#{ second_access_token.id }'] [data-action='session.delete']").click

    # Redirect to the correct post action route route
    assert_current_path post_action_route_url
    expect(page).to have_content post_action_route_id

    # Display the expected notification
    flash_text = I18n.t('kit.auth.notifications.sign_out.devices.success', email: user.email)
    expect(page.body.include?(flash_text)).to be true

    # Access token has been revoked
    second_access_token.reload
    expect(second_access_token.revoked?).to be true

    # Force a visit back to the settings page (since the redirect is tested on a different url)
    visit route_id_to_path(id: 'web|settings|sessions')

    # List has been updated
    expect(page).to have_selector('[data-type="session.device"]', count: 1)
  end

end
