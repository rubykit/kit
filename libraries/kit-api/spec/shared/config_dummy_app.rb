require_relative '../dummy/config/initializers/api_config'

RSpec.shared_context 'config dummy app' do

  let(:config_dummy_app) { KIT_DUMMY_APP_API_CONFIG.deep_dup }

end
