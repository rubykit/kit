require_relative '../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|sign_in', type: :feature do

  let(:email)    { 'user@rubykit.com' }
  let(:password) { 'Abcd12_xxxxxxxxx' }
  let(:user)     { create_user(email: email, password: password) }

  it 'signs the user in' do
    user

    visit route_uid_to_path('web|users|sign_in')

    within('form.component_forms_signin-form') do
      fill_in 'Email',    with: email
      fill_in 'Password', with: password
    end

    click_button I18n.t('kit.auth.pages.users.sign_in.with_password.submit')

    assert_current_path route_uid_to_path('web|users|sign_in|after')
    expect(page).to have_content I18n.t('kit.auth.pages.header.sign_out.action')
  end

end
