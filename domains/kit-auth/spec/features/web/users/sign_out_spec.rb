require_relative '../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|sign_out', type: :feature do

  let(:password) { 'xxxxxx' }
  let(:user)     { create(:user, password: password) }

  before do
    web_sign_in(email: user.email, password: password)
  end

  it 'signs the user out' do
    # Calls the correct event endpoint
    expect(Kit::Router::Services::Adapters).to receive(:cast)
      .with(hash_including(route_id: 'event|user|auth|sign_out', params: hash_including(user_id: user.id)))

    # Click the top-bar link for sign-out
    click_link I18n.t('kit.auth.pages.header.sign_out.action')

    # Redirect to the correct post action route route
    assert_current_path route_id_to_path(id: 'web|users|sign_out|after')

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
