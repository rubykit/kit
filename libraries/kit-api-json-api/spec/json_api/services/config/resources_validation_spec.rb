require_relative '../../../rails_helper'

describe Kit::Api::JsonApi::Services::Config do
  include_context 'config dummy app'

  let(:service)  { described_class }
  let(:subject)  { service.validate_config_resources(config: config) }

  context 'with a valid config' do
    let(:config) { config_dummy_app }

    it 'succeeds' do
      status, _ctx = subject
      expect(status).to eq :ok
    end
  end

  context 'with an invalid config' do

    context 'with a relationship missing its type' do
      let(:config) do
        local_config = config_dummy_app
        local_config[:resources][:author][:relationships][:books][:resource] = nil
        local_config
      end

      it 'fails' do
        status, ctx = subject
        expect(status).to eq :error
        expect(ctx[:errors][0][:detail]).to eq 'Kit::Api::JsonApi - Error: missing resource for relationship `author.books`'
      end
    end

    context 'with a relationship referencing an unregistered type' do
      let(:config) do
        local_config = config_dummy_app
        local_config[:resources][:book] = nil
        local_config
      end

      it 'fails' do
        status, ctx = subject
        expect(status).to eq :error
        expect(ctx[:errors][0][:detail]).to eq 'Kit::Api::JsonApi - Error: unregistered resource `book` for relationship `author.books`'
      end
    end

  end

end
