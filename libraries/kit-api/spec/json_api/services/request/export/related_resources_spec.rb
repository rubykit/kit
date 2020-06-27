require_relative '../../../../rails_helper'

describe Kit::Api::JsonApi::Services::Request::Export::RelatedResources do
  include_context 'config dummy app'

  let(:service)  { described_class }

  let(:config)   { config_dummy_app }

  let(:api_request) do
    {
      config:             config,
      top_level_resource: Kit::JsonApiSpec::Resources::Author.to_h,
      related_resources:  related_resources,
    }
  end

  describe '.handle_related_resources' do
    subject do
      included_paths = service.included_paths(
        api_request: api_request,
        path:        path,
      )[1][:included_paths]
      service.handle_related_resources(
        query_params:   {},
        api_request:    api_request,
        included_paths: included_paths,
      )
    end

    context 'with matching path resources' do
      # 'a' is the implicit top level resource
      let(:related_resources) do
        {
          'b'       => 1,
          'b.c'     => 1,
          'b.z'     => 1,
          'b.c.d'   => 1,
          'b.c.f'   => 1,
          'b.z.x'   => 1,
          'b.c.d.e' => 1,
          'b.z.x.m' => 1,
        }
      end

      context 'with a top level path' do
        let(:path) { '' }

        it 'add the expected data to the request' do
          status, ctx = subject
          expect(status).to eq :ok
          expect(ctx[:query_params][:include]).to eq 'b.c.d.e,b.c.f,b.z.x.m'
        end
      end

      context 'with a nested path' do
        let(:path) { 'b.c' }

        it 'add the expected data to the request' do
          status, ctx = subject
          expect(status).to eq :ok
          expect(ctx[:query_params][:include]).to eq 'd.e,f'
        end
      end
    end

    context 'with non matching paths resources' do
      let(:related_resources) do
        {
          'a' => 1,
        }
      end
      let(:path) { 'x.y' }

      it 'add the expected data to the request' do
        status, ctx = subject
        expect(status).to eq :ok
        expect(ctx[:query_params][:include]).to be nil
      end
    end

  end

end
