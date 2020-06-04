require_relative '../../../../rails_helper'

describe Kit::Api::JsonApi::Services::Request::Export::RelatedResources do
  include_context 'config dummy app'

  let(:service)  { described_class }

  let(:config)   { config_dummy_app }

  let(:request) do
    {
      config:             config,
      top_level_resource: Kit::JsonApiSpec::Resources::Author.to_h,
      related_resources:  related_resources,
    }
  end

  describe '.handle_related_resources' do
    subject do
      included_paths = service.included_paths(
        request: request,
        path:    path,
      )[1][:included_paths]
      service.handle_related_resources(
        query_params:   {},
        request:        request,
        included_paths: included_paths,
      )
    end

    context 'with valid resources' do
      let(:related_resources) do
        {
          'a'       => 1,
          'a.b'     => 1,
          'a.z'     => 1,
          'a.b.c'   => 1,
          'a.b.e'   => 1,
          'a.z.x'   => 1,
          'a.b.c.d' => 1,
          'a.z.x.m' => 1,
        }
      end
      let(:path) { 'a.b' }

      it 'add the expected data to the request' do
        status, ctx = subject
        expect(status).to eq :ok
        expect(ctx[:query_params][:include]).to eq 'c.d,e'
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
