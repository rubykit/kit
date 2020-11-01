require_relative '../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|sign_up', type: :feature do

  let(:email)    { 'user@rubykit.com' }
  let(:password) { 'Abcd12_xxxxxxxxx' }

  it 'signs the user in' do
    expect(Kit::Auth::Models::Write::User.where(email: email).count).to eq 0

    visit route_uid_to_path('web|users|sign_up')

    within('form.component_forms_signup-form') do
      fill_in 'Email',                 with: email
      fill_in 'Password',              with: password
      fill_in 'Password confirmation', with: password
    end

    click_button 'Sign Up'

    assert_current_path route_uid_to_path('web|users|after_sign_up')
    expect(page).to have_content 'Sign out'

    expect(Kit::Auth::Models::Write::User.where(email: email).count).to eq 1
  end

end
