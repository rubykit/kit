module Helpers::Omniauth

  RSpec.shared_context 'omniauth' do

    let(:omniauth_mock_data_facebook) do
      omniauth_facebook_mock(
        omniauth_strategy: omniauth_strategy,
        email:             email,
      )
    end

    let(:omniauth_mock_data_linkedin) do
      omniauth_linkedin_mock(
        omniauth_strategy: omniauth_strategy,
        email:             email,
      )
    end

    before do
      OmniAuth.config.test_mode = true

      OmniAuth.config.mock_auth[omniauth_strategy]  = omniauth_mock_data
      Rails.application.env_config['omniauth.auth'] = omniauth_mock_data

      Kit::Auth::Services::Oauth.providers.clear
      Kit::Auth::Services::Oauth.providers << {
        group:             :web,
        external_name:     omniauth_provider,
        internal_name:     omniauth_provider,
        omniauth_strategy: omniauth_strategy,
      }
    end

    after do
      Rails.application.env_config['omniauth.auth'] = nil
      OmniAuth.config.test_mode = false
    end

  end

end
