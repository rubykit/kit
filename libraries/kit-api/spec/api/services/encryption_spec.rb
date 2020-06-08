require_relative '../../rails_helper'

require 'securerandom'

describe Kit::Api::Services::Encryption do

  let(:service)  { described_class }

  let(:random_secret) { SecureRandom.hex(16) }
  let(:random_data)   { SecureRandom.hex(6) }

  context 'encrypt' do

    context 'with invalid data' do
      let(:key_encrypt) { random_secret }
      let(:invalid_values) { [nil, ''] }

      it 'fails for each invalid data value' do
        invalid_values.each do |data|
          status_e, ctx_e = service.encrypt(data: data, key: key_encrypt)

          expect(status_e).to                   eq :error
          expect(ctx_e[:errors][0][:detail]).to eq 'Invalid data to encrypt.'
        end
      end
    end

    context 'with an invalid key' do
      let(:data)         { random_data }
      #let(:invalid_keys) { [nil, random_secret[0...-1]] }
      let(:invalid_keys) { [random_secret[0...-1]] }

      it 'fails for each invalid key' do
        invalid_keys.each do |key_encrypt|
          status_e, ctx_e = service.encrypt(data: data, key: key_encrypt)

          expect(status_e).to                   eq :error
          expect(ctx_e[:errors][0][:detail]).to eq 'Invalid encryption key.'
        end
      end
    end

  end

  context 'decrypt' do

    context 'with invalid data string' do
      let(:key_decrypt)    { '21a890fe10749cbf50c7b7b136f38736' }
      let(:invalid_values) do
        [
          nil,
          '',
          'asKJlkjJHkjh',
          'vvkf7fnwqx4df2h5dmd99cnlyyZ6m7jm9bnjh518jsv1dywvt63qy', # Payload `":a":1}` encrypted with `key_decrypt` to make Oj.load fail
          'fnqfhAwxd4cvwc3dgyvyb7njhAZhxnw39wdy0Aqzftw3pdw497q3q', # Payload `{":a":1}` encrypted with key `e290efcdaeba31fe77a65851c5224e9a`
        ]
      end

      it 'fails for each invalid data value' do
        invalid_values.each do |data|
          status_d, ctx_d = service.decrypt(encrypted_data: data, key: key_decrypt)

          expect(status_d).to                   eq :error
          expect(ctx_d[:errors][0][:detail]).to eq 'Invalid string to decrypt.'
        end
      end
    end

    context 'with an invalid key' do
      let(:valid_data)   { 'fnqfhAwxd4cvwc3dgyvyb7njhAZhxnw39wdy0Aqzftw3pdw497q3q' } # Payload `{":a":1}` encrypted with key `e290efcdaeba31fe77a65851c5224e9a`
      let(:invalid_keys) { [nil, random_secret[0...-1]] }

      it 'fails for each invalid key' do
        invalid_keys.each do |key_decrypt|
          status_d, ctx_d = service.decrypt(encrypted_data: valid_data, key: key_decrypt)

          expect(status_d).to                   eq :error
          expect(ctx_d[:errors][0][:detail]).to eq 'Invalid encryption key.'
        end
      end
    end

  end

  context 'encrypt & decrypt' do

    context 'with the same key' do
      let(:data)        { random_data }
      let(:key)         { random_secret }
      let(:key_encrypt) { key }
      let(:key_decrypt) { key }

      it 'works' do
        status_e, ctx_e = service.encrypt(data: data, key: key_encrypt)

        expect(status_e).to eq :ok
        expect(ctx_e[:encrypted_data]).not_to be nil
        expect(ctx_e[:encrypted_data].size).to be > 0
        expect(ctx_e[:encrypted_data]).not_to eq data

        status_d, ctx_d = service.decrypt(encrypted_data: ctx_e[:encrypted_data], key: key_decrypt)

        expect(status_d).to eq :ok
        expect(ctx_d[:data]).to eq data
      end
    end

    context 'with a different key' do
      let(:data)        { random_data }
      let(:key_encrypt) { '21a890fe10749cbf50c7b7b136f38736' }
      let(:key_decrypt) { 'e290efcdaeba31fe77a65851c5224e9a' }

      it 'fails' do
        status_e, ctx_e = service.encrypt(data: data, key: key_encrypt)

        expect(status_e).to eq :ok
        expect(ctx_e[:encrypted_data]).not_to be nil
        expect(ctx_e[:encrypted_data].size).to be > 0
        expect(ctx_e[:encrypted_data]).not_to eq data

        status_d, ctx_d = service.decrypt(encrypted_data: ctx_e[:encrypted_data], key: key_decrypt)

        expect(status_d).to eq :error
        expect(ctx_d[:errors][0][:detail]).to eq 'Invalid string to decrypt.'
      end
    end

  end

end
