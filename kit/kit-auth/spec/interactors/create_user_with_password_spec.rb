require 'rails_helper'

describe "Kit::Auth::Interactors::CreateUserWithPassword" do
  let(:interactor) { Kit::Auth::Interactors::CreateUserWithPassword }
  let(:subject)    { interactor.call ctx_hash }

  let(:result)  { subject[0] }
  let(:ctx_res) { subject[1] }

  let(:ctx_hash) do
    {
      email: email,
      password: password,
    }
  end

  context 'with valid data' do
    let(:email)    { 'test@test.com' }
    let(:password) { 'xxx' }

    it 'creates a user' do
      expect(Kit::Auth::Models::Read::User.count).to eq 0
      expect(subject[0]).to eq :ok
      expect(Kit::Auth::Models::Read::User.count).to eq 1
    end
  end

  context 'with an empty email' do
    let(:email)    { '' }
    let(:password) { 'xxx' }

    it 'errors out' do
      expect(ctx_res[:errors].first).to eq [:email, "can't be blank"]
    end
  end

end