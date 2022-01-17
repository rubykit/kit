require_relative '../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|password_reset|edit', type: :feature do

  let(:route_id) { 'web|users|password_reset|edit' }

  let(:old_password) { 'xxxxxx' }
  let(:new_password) { "#{ old_password }_new" }

  let(:user)         { create(:user, password: old_password) }

  let(:access_token)                  { create_access_token[1][:access_token] }
  let(:access_token_plaintext_secret) { create_access_token[1][:access_token_plaintext_secret] }

  let(:post_action_route_url) { route_id_to_path(id: post_action_route_id) }

  before do
    user
    create_access_token

    expect(Kit::Auth::Actions::Users::VerifyPassword.call(user: user, password: new_password)[0]).to eq :error
  end

  context 'with a token with valid scope' do

    let(:create_access_token)  { Kit::Auth::Actions::AccessTokens::CreateForPasswordReset.call(user: user, application: app_web) }
    let(:post_action_route_id) { 'web|users|password_reset|after' }

    it 'lets the user update its password' do
      # Calls the correct event endpoint
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|users|password_reset', params: hash_including(user_id: user.id)))
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|user|auth|sign_in', params: hash_including(user_id: user.id, sign_in_method: :password)))

      # Visit the page
      visit route_id_to_path(id: route_id, params: { access_token: access_token_plaintext_secret })

      # Fill the form
      within('form') do
        fill_in 'Password',             with: new_password
        fill_in 'Confirm new password', with: new_password
      end

      click_button I18n.t('kit.auth.pages.users.password_reset.submit')

      # Redirect to the correct post action route route
      assert_current_path post_action_route_url
      expect(page).to have_content post_action_route_id

      # Display the expected notification
      flash_text = I18n.t('kit.auth.notifications.password_reset.success', email: user.email)
      expect(page.body.include?(flash_text)).to be true

      # Access token has been revoked
      access_token.reload
      expect(access_token.revoked?).to be true

      # Secret has been updated
      user.reload
      expect(Kit::Auth::Actions::Users::VerifyPassword.call(user: user, password: new_password)[0]).to eq :ok

      # User has been signed-in
      expect(page).to have_content I18n.t('kit.auth.pages.header.sign_out.action')
    end

  end

  context 'with a token with invalid scope' do

    let(:create_access_token)  { Kit::Auth::Actions::AccessTokens::CreateForSignIn.call(user: user, application: app_web) }
    let(:post_action_route_id) { 'web|users|sign_in|with_password|new' }

    it 'redirects with the correct error message' do
      # Visit the page
      visit route_id_to_path(id: route_id, params: { access_token: access_token_plaintext_secret })

      # Redirect to the correct post action route route (sign-in page)
      assert_current_path post_action_route_url

      # Display the expected notification
      flash_text = I18n.t('kit.auth.notifications.scopes.missing', scopes: [Kit::Auth::Services::Scopes::USER_PASSWORD_UPDATE])
      expect(page.body.include?(flash_text)).to be true

      # Secret has NOT been updated
      user.reload
      expect(Kit::Auth::Actions::Users::VerifyPassword.call(user: user, password: new_password)[0]).not_to eq :ok
    end

  end

end
