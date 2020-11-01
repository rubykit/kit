require 'rails_helper'

describe Kit::Auth::Services::Password do
  let(:service) { described_class }

  context 'generating hashed secret' do
    let(:password)      { 'Ax7^IhkjgF*H' }

    it 'when generating a hashed_secret it matches against it' do
      status, ctx   = service.generate_hashed_secret(password: password)
      hashed_secret = ctx[:hashed_secret]

      expect(status).to eq :ok
      expect(hashed_secret).not_to be_nil

      valid_password = service.valid_password?(reference_hashed_secret: hashed_secret, password: password)

      expect(valid_password).to eq true
    end
  end

end
