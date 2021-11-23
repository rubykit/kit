require_relative '../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|sign_out', type: :feature do

  let(:password) { 'xxxxxx' }
  let(:user)     { create(:user, password: password) }

  let(:post_action_route_id)  { 'web|users|sign_out|after' }
  let(:post_action_route_url) { route_id_to_path(id: post_action_route_id) }

  before do
    web_real_sign_in(email: user.email, password: password)
  end

  let(:user_secret) { user.user_secrets.find_by(category: :access_token) }

  it 'signs the user out through the top-bar' do
    # Calls the correct event endpoint
    expect(Kit::Router::Services::Adapters).to receive(:cast)
      .with(hash_including(route_id: 'event|user|auth|sign_out', params: hash_including(user_id: user.id, user_secret_id: user_secret.id)))
    expect(Kit::Router::Services::Adapters).to receive(:cast)
      .with(hash_including(route_id: 'event|user|auth|access_token|revoked', params: hash_including(user_id: user.id, user_secret_id: user_secret.id)))

    # Click the top-bar link for sign-out
    click_link I18n.t('kit.auth.pages.header.sign_out.action')

    # Redirect to the correct post action route route
    assert_current_path post_action_route_url
    expect(page).to have_content post_action_route_id

    # Display the expected notification
    flash_text = I18n.t('kit.auth.notifications.sign_out.success', email: user.email)
    expect(page.body.include?(flash_text)).to be true

    # Access token has been revoked
    access_token = user.user_secrets.last
    expect(access_token.revoked?).to be true

    # User has been signed-out
    expect(page).to have_content I18n.t('kit.auth.pages.header.sign_in.action')
  end

  it 'signs the user out through the endpoint' do
    # Calls the correct event endpoint
    expect(Kit::Router::Services::Adapters).to receive(:cast)
      .with(hash_including(route_id: 'event|user|auth|sign_out', params: hash_including(user_id: user.id, user_secret_id: user_secret.id)))
    expect(Kit::Router::Services::Adapters).to receive(:cast)
      .with(hash_including(route_id: 'event|user|auth|access_token|revoked', params: hash_including(user_id: user.id, user_secret_id: user_secret.id)))

    # Visit the url
    visit_route_id(id: 'web|authorization_tokens|destroy')

    # Redirect to the correct post action route route
    assert_current_path post_action_route_url
    expect(page).to have_content post_action_route_id

    # Display the expected notification
    flash_text = I18n.t('kit.auth.notifications.sign_out.success', email: user.email)
    expect(page.body.include?(flash_text)).to be true

    # Access token has been revoked
    access_token = user.user_secrets.last
    expect(access_token.revoked?).to be true

    # User has been signed-out
    expect(page).to have_content I18n.t('kit.auth.pages.header.sign_in.action')
  end

end
