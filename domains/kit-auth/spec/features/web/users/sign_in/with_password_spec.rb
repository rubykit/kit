require_relative '../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|sign_in|with_password|new', type: :feature do
  let(:route_id) { 'web|users|sign_in|with_password|new' }

  let(:email)    { 'user@rubykit.com' }
  let(:password) { 'Abcd12_xxxxxxxxx' }
  let(:user)     { create(:user, email: email, password: password) }

  let(:post_action_route_url) { route_id_to_path(id: post_action_route_id) }

  before do
    user
  end

  shared_examples 'a successful sign-in' do
    it 'signs the user in' do
      # Calls the correct event endpoint
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|user|auth|sign_in', params: hash_including(user_id: user.id, sign_in_method: :password)))

      # Visit the page && fill the form
      visit start_route_url

      within('form.component_forms_signin-form') do
        fill_in 'Email',    with: email
        fill_in 'Password', with: password
      end

      click_button I18n.t('kit.auth.pages.users.sign_in.with_password.submit')

      # Redirect to the correct post action route route
      assert_current_path post_action_route_url
      expect(page).to have_content post_action_route_id

      # User has been signed-in
      expect(page).to have_content I18n.t('kit.auth.pages.header.sign_out.action')

      # Display the expected notification
      flash_text = I18n.t('kit.auth.notifications.sign_in.success', email: email)
      expect(page.body.include?(flash_text)).to be true
    end
  end

  context 'with valid sign-in data' do
    let(:start_route_url)      { route_id_to_path(id: route_id) }
    let(:post_action_route_id) { 'web|users|sign_in|after' }

    it_behaves_like 'a successful sign-in'
  end

  context 'with sign in intent' do
    let(:start_route_url)      { route_id_to_path(id: route_id, params: { intent: intent_type }) }
    let(:post_action_route_id) { 'web|intent|post_sign_in' }

    let(:intent_type)          { :user_auth }

    before do
      Kit::Router::Adapters::Http::Intent::Store.default_intent_store[intent_type] = {
        get: ->(router_conn:, **)                { [:ok, intent_value: 'not_used_here_anyway'] },
        use: ->(router_conn:, intent_value:, **) { [:ok, redirect_url: post_action_route_url] },
      }

      # Ensure the intent route is not aliased on the same mount point.
      expect(post_action_route_url).not_to eq route_id_to_path(id: 'web|users|sign_in|after')
    end

    after do
      Kit::Router::Adapters::Http::Intent::Store.default_intent_store[intent_type] = nil
    end

    it_behaves_like 'a successful sign-in'
  end

end
