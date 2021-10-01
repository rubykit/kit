require_relative '../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|sign_in', type: :feature do

  let(:email)    { 'user@rubykit.com' }
  let(:password) { 'Abcd12_xxxxxxxxx' }
  let(:user)     { create_user(email: email, password: password) }

  before do
    user
  end

  it 'signs the user in' do
    # Calls the correct event endpoint
    expect(Kit::Router::Services::Adapters).to receive(:cast)
      .with(hash_including(route_id: 'event|user|auth|sign_in', params: hash_including(user_id: user.id, sign_in_method: :password)))

    # Visit the page && fill the form
    visit route_id_to_path(id: subject)

    within('form.component_forms_signin-form') do
      fill_in 'Email',    with: email
      fill_in 'Password', with: password
    end

    click_button I18n.t('kit.auth.pages.users.sign_in.with_password.submit')

    # Redirect to the correct post action route route
    assert_current_path route_id_to_path(id: 'web|users|sign_in|after')

    # User has been signed-in
    expect(page).to have_content I18n.t('kit.auth.pages.header.sign_out.action')

    # Display the expected notification
    flash_text = I18n.t('kit.auth.notifications.sign_in.success', email: email)
    expect(page.body.include?(flash_text)).to be true
  end

end
