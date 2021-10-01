require_relative '../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|password_reset_request|new', type: :feature do

  let(:email)    { 'user@rubykit.com' }
  let(:user)     { create_user(email: email) }

  before do
    user
  end

  it 'when user exists' do
    # Calls the correct event endpoint
    expect(Kit::Router::Services::Adapters).to receive(:cast)
      .with(hash_including(route_id: 'event|users|password_reset_request', params: hash_including(email: email)))

    # Visit the page && fill the form
    visit route_id_to_path(id: subject)

    within('form') do
      fill_in 'Email', with: email
    end

    click_button I18n.t('kit.auth.pages.users.password.reset_request.submit')

    # Redirect to the correct post action route route
    assert_current_path route_id_to_path(id: 'web|users|password_reset_request|after')

    # Display the expected notification
    flash_text = I18n.t('kit.auth.notifications.password_reset_request.success', email: email)
    expect(page.body.include?(flash_text)).to be true
  end

end
