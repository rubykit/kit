require 'rails_helper'

describe Kit::Auth::Actions::Users::CreateUserWithPassword  do
  let(:interactor) { described_class }
  let(:subject)    { interactor.call ctx_hash }

  let(:result)  { subject[0] }
  let(:ctx_res) { subject[1] }

  let(:ctx_hash) do
    {
      email:                 email,
      password:              password,
      password_confirmation: password_confirmation,
    }
  end

  let(:password_ok) { 'Ax7^IhkjgF*H' }
  let(:password_error) { 'xxxxxx' }

  let(:email_ok) { 'email@gmail.com' }
  let(:email_error) { 'email@gmail..com' }

  let(:password_confirmation) { password }

  context 'with valid data' do
    let(:email)    { email_ok }
    let(:password) { password_ok }

    it 'creates a user' do
      expect(Kit::Auth::Models::Read::User.count).to eq 0
      expect(subject[0]).to eq :ok
      expect(Kit::Auth::Models::Read::User.count).to eq 1
    end
  end

  context 'with an empty email' do
    let(:email)    { email_error }
    let(:password) { password_ok }

    it 'errors out' do
      expect(ctx_res[:errors][:email]).to eq ['has invalid format']
    end
  end

end
