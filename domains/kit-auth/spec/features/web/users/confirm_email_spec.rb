require_relative '../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|email|confirm', type: :feature do
  let(:route) { 'web|users|email|confirm' }

  let(:user)       { create(:user) }
  let(:user_email) { user.primary_user_email }

  let(:create_access_token)           { Kit::Auth::Actions::AccessTokens::CreateForEmailConfirmation.call(user: user, user_email: user_email, application: app_web) }
  let(:access_token)                  { create_access_token[1][:access_token] }
  let(:access_token_plaintext_secret) { create_access_token[1][:access_token_plaintext_secret] }

  let(:post_action_route_url)         { route_id_to_path(id: post_action_route_id) }

  before do
    user
    create_access_token

    expect(user_email.confirmed?).to be false
  end

  shared_examples 'confirms the email' do
    it 'confirms the email' do
      # Calls the correct event endpoint
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|users|email_confirmed', params: hash_including(user_email_id: user_email.id)))

      # Visit the page
      visit route_id_to_path(id: route, params: { access_token: access_token_plaintext_secret })

      # Redirect to the correct post action route route
      assert_current_path post_action_route_url
      expect(page).to have_content post_action_route_id

      # Display the expected notification
      flash_text = I18n.t('kit.auth.notifications.email_confirmation.success', email: user.email)
      expect(page.body.include?(flash_text)).to be true

      # Access token has been revoked
      access_token.reload
      expect(access_token.revoked?).to be true

      # Email has been confirmed
      user_email.reload
      expect(user_email.confirmed?).to be true
    end
  end

  context 'when the user is signed_out' do
    let(:post_action_route_id)  { 'web|users|email_confirmation|after|signed_out' }

    it_behaves_like 'confirms the email'
  end

  context 'when the user is signed_in' do
    let(:post_action_route_id)  { 'web|users|email_confirmation|after|signed_in' }

    before do
      web_sign_in(user: user)
    end

    it_behaves_like 'confirms the email'
  end

end
