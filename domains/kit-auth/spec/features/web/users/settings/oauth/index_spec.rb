require_relative '../../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|settings|oauth', type: :feature do

  let(:user)     { create(:user) }

  let(:first_user_oauth_identity)  { create(:user_oauth_identity, user: user, provider: :facebook) }
  let(:second_user_oauth_identity) { create(:user_oauth_identity, user: user, provider: :facebook) }

  before do
    web_sign_in(user: user)

    expect(first_user_oauth_identity.id).not_to eq second_user_oauth_identity.id
  end

  it 'lists the active oauth accounts' do
    visit route_id_to_path(id: 'web|settings|oauth')

    expect(page).to have_selector('[data-type="oauth_identity"]', count: 2)
  end

end
