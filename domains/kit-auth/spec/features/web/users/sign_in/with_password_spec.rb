require_relative '../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|sign_in', type: :feature do
  let(:route_id) { 'web|users|sign_in' }

  let(:email)    { 'user@rubykit.com' }
  let(:password) { 'Abcd12_xxxxxxxxx' }
  let(:user)     { create_user(email: email, password: password) }

  let(:default_post_action_route) { route_id_to_path(id: 'web|users|sign_in|after') }

  before do
    user
  end

  shared_examples 'a successful sign-in' do
    it 'signs the user in' do
      # Calls the correct event endpoint
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|user|auth|sign_in', params: hash_including(user_id: user.id, sign_in_method: :password)))

      # Visit the page && fill the form
      visit start_route

      within('form.component_forms_signin-form') do
        fill_in 'Email',    with: email
        fill_in 'Password', with: password
      end

      click_button I18n.t('kit.auth.pages.users.sign_in.with_password.submit')

      # Redirect to the correct post action route route
      assert_current_path post_action_route

      # User has been signed-in
      expect(page).to have_content I18n.t('kit.auth.pages.header.sign_out.action')

      # Display the expected notification
      flash_text = I18n.t('kit.auth.notifications.sign_in.success', email: email)
      expect(page.body.include?(flash_text)).to be true
    end
  end

  context 'with valid sign-in data' do
    let(:start_route)       { route_id_to_path(id: route_id) }
    let(:post_action_route) { default_post_action_route }

    it_behaves_like 'a successful sign-in'
  end

  context 'with sign in intent' do
    let(:intent_type)       { :spec_sign_in }
    let(:start_route)       { route_id_to_path(id: route_id, params: { intent: intent_type }) }
    let(:post_action_route) { route_id_to_path(id: 'web|intent|post_sign_in') }

    before do
      Kit::Auth::Services::Intent.default_intent_store[:types][intent_type] = ->(router_conn:) { [:ok, redirect_url: post_action_route] }
      expect(post_action_route).not_to eq default_post_action_route
    end

    it_behaves_like 'a successful sign-in'
  end

end