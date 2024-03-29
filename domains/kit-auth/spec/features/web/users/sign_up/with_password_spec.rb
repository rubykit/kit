require_relative '../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|sign_up|with_password|new', type: :feature do
  let(:route_id) { 'web|users|sign_up|with_password|new' }

  let(:email)    { 'user@rubykit.com' }
  let(:password) { 'Abcd12_xxxxxxxxx' }

  let(:post_action_route_url) { route_id_to_path(id: post_action_route_id) }

  before do
    expect(Kit::Auth::Models::Write::User.where(email: email).count).to eq 0
  end

  shared_examples 'a successful sign-up' do
    it 'creates the user account' do
      # Calls the correct event endpoint
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|users|auth|sign_up', params: hash_including(user_id: instance_of(Integer), sign_up_method: :email)))
      expect(Kit::Router::Services::Adapters).to receive(:cast)
        .with(hash_including(route_id: 'event|users|auth|sign_in', params: hash_including(user_id: instance_of(Integer), sign_in_method: :password)))

      # Visit the page && fill the form
      visit start_route_url

      within('form.component_forms_signup-form') do
        fill_in 'Email',                 with: email
        fill_in 'Password',              with: password
        fill_in 'Password confirmation', with: password
      end

      click_button I18n.t('kit.auth.pages.header.sign_up.action')

      # Redirect to the correct post action route route
      assert_current_path post_action_route_url
      expect(page).to have_content post_action_route_id

      # User has been signed-in
      expect(page).to have_content I18n.t('kit.auth.pages.header.sign_out.action')

      # Display the expected notification
      flash_text = I18n.t('kit.auth.notifications.sign_up.success', email: email)
      expect(page.body.include?(flash_text)).to be true

      # Added a user in the db
      expect(Kit::Auth::Models::Write::User.where(email: email).count).to eq 1
    end
  end

  context 'with valid sign-up data' do
    let(:start_route_url)           { route_id_to_path(id: route_id) }
    let(:post_action_route_id)  { 'web|users|sign_up|after' }

    it_behaves_like 'a successful sign-up'
  end

  context 'with sign up intent' do
    let(:start_route_url)      { route_id_to_path(id: route_id, params: { intent: intent_type }) }
    let(:post_action_route_id) { 'web|intent|post_sign_up' }

    let(:intent_type)          { :user_auth }

    before do
      Kit::Router::Adapters::Http::Intent::Store.default_intent_store[intent_type] = {
        get: ->(router_conn:, **)                { [:ok, intent_value: 'not_used_here_anyway'] },
        use: ->(router_conn:, intent_value:, **) { [:ok, redirect_url: post_action_route_url] },
      }

      # Ensure the intent route is not aliased on the same mount point.
      expect(post_action_route_url).not_to eq route_id_to_path(id: 'web|users|sign_up|after')
    end

    after do
      Kit::Router::Adapters::Http::Intent::Store.default_intent_store[intent_type] = nil
    end

    it_behaves_like 'a successful sign-up'
  end

end
