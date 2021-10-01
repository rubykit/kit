require_relative '../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|sign_up', type: :feature do

  let(:email)    { 'user@rubykit.com' }
  let(:password) { 'Abcd12_xxxxxxxxx' }

  before do
    expect(Kit::Auth::Models::Write::User.where(email: email).count).to eq 0
  end

  it 'creates the user account' do
    # Calls the correct event endpoint
    expect(Kit::Router::Services::Adapters).to receive(:cast)
      .with(hash_including(route_id: 'event|user|auth|sign_up', params: hash_including(user_id: instance_of(Integer), sign_up_method: :email)))
    expect(Kit::Router::Services::Adapters).to receive(:cast)
      .with(hash_including(route_id: 'event|user|auth|sign_in', params: hash_including(user_id: instance_of(Integer), sign_in_method: :password)))

    # Visit the page && fill the form
    visit route_id_to_path(id: subject)

    within('form.component_forms_signup-form') do
      fill_in 'Email',                 with: email
      fill_in 'Password',              with: password
      fill_in 'Password confirmation', with: password
    end

    click_button I18n.t('kit.auth.pages.header.sign_up.action')

    # Redirect to the correct post action route route
    assert_current_path route_id_to_path(id: 'web|users|sign_up|after')

    # User has been signed-in
    expect(page).to have_content I18n.t('kit.auth.pages.header.sign_out.action')

    # Display the expected notification
    flash_text = I18n.t('kit.auth.notifications.sign_up.success', email: email)
    expect(page.body.include?(flash_text)).to be true

    # Added a user in the db
    expect(Kit::Auth::Models::Write::User.where(email: email).count).to eq 1
  end

end
