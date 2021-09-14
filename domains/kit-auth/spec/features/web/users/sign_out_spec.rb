require_relative '../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|sign_out', type: :feature do

  it 'signs the user out' do
    web_sign_in

    click_link I18n.t('kit.auth.pages.header.sign_out.action')

    assert_current_path route_uid_to_path('web|users|sign_out|after')
    expect(page).to have_content I18n.t('kit.auth.pages.header.sign_in.action')
  end

end
