require_relative '../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|sign_in|with_magic_link|create', type: :feature do

  let(:user) { create(:user) }

  let(:create_access_token)           { Kit::Auth::Actions::AccessTokens::CreateForMagicLink.call(user: user, application: app_web) }
  let(:access_token)                  { create_access_token[1][:access_token] }
  let(:access_token_plaintext_secret) { create_access_token[1][:access_token_plaintext_secret] }

  let(:post_action_route_id)  { 'web|users|sign_in|after' }
  let(:post_action_route_url) { route_id_to_path(id: post_action_route_id) }

  before do
    user
    create_access_token
  end

  it 'signs the user in' do
    # Calls the correct event endpoint
    expect(Kit::Router::Services::Adapters).to receive(:cast)
      .with(hash_including(route_id: 'event|users|auth|sign_in', params: hash_including(user_id: user.id, sign_in_method: :link)))

    # Visit the page
    visit route_id_to_path(id: subject, params: { access_token: access_token_plaintext_secret })

    # Redirect to the correct post action route route
    assert_current_path post_action_route_url
    expect(page).to have_content post_action_route_id

    # User has been signed-in
    expect(page).to have_content I18n.t('kit.auth.pages.header.sign_out.action')

    # Display the expected notification
    flash_text = I18n.t('kit.auth.notifications.sign_in.success', email: user.email)
    expect(page.body.include?(flash_text)).to be true

    # Access token has been revoked
    access_token.reload
    expect(access_token.revoked?).to be true
  end

end
