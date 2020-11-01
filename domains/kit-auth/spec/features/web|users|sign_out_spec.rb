require_relative '../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|sign_out', type: :feature do

  it 'signs the user out' do
    web_sign_in

    click_link 'Sign out'

    assert_current_path route_uid_to_path('web|users|after_sign_out')
    expect(page).to have_content 'Sign in'
  end

end
