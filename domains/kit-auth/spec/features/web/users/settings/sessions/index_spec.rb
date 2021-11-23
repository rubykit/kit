require_relative '../../../../../rails_helper' # rubocop:disable Naming/FileName

describe 'web|settings|sessions', type: :feature do

  let(:user)     { create(:user) }

  let(:first_access_token) { user.user_secrets.order(created_at: :asc).where(category: :access_token).first }
  let(:second_access_token) do
    Kit::Auth::Actions::AccessTokens::CreateForSignIn
      .call(
        user:        user,
        application: Kit::Auth::Actions::Applications::LoadWeb.call[1][:application],
      )[1][:access_token]
  end

  before do
    web_sign_in(user: user)

    expect(second_access_token.id).not_to eq first_access_token.id
  end

  it 'lists the active access_tokens' do
    visit route_id_to_path(id: 'web|settings|sessions')

    expect(page).to have_selector('[data-type="session.device"]', count: 2)
  end

end
