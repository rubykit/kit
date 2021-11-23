require_relative '../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|users|sign_in_link_request|new', type: :feature do

  let(:email)    { 'user@rubykit.com' }
  let(:user)     { create(:user, email: email) }

  before do
    user
  end

  it 'when user exists' do
    # Calls the correct event endpoint
    expect(Kit::Router::Services::Adapters).to receive(:cast)
      .with(hash_including(route_id: 'event|users|sign_in_link_request', params: hash_including(email: email)))

    # Visit the page && fill the form
    visit route_id_to_path(id: subject)

    within('form') do
      fill_in 'Email', with: email
    end

    click_button I18n.t('kit.auth.pages.users.sign_in.with_magic_link.submit')

    # Redirect to the correct post action route route
    assert_current_path route_id_to_path(id: 'web|users|sign_in_link_request|create')
    expect(page).to have_content I18n.t('kit.auth.pages.users.sign_in.with_magic_link.after.title')
  end

end
