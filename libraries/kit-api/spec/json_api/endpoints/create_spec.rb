require_relative '../../rails_helper'

describe 'Json:Api CREATE requests', type: :request do
  include_context 'config dummy app'
  include_context 'json:api'
  include_context 'url'

  let(:subject) { post request_path, headers: jsonapi_headers, params: body }

  shared_examples 'returns valid JSON:API data' do
    let(:route_id) { "specs|api|#{ resource_name }|create" }

    let(:query_params) do
      { include: '' }
    end

    let(:tmp_model_instance)    { FactoryBot.create(resource_name) }

    let(:attributes_payload) do
      resource[:writeable_attributes]
        .map { |name, properties| [name, tmp_model_instance.send(properties[:field])] }
        .to_h
    end
    let(:attributes_payload_serialized) { Oj.safe_load(Oj.dump(attributes_payload, mode: :json)) }
    let(:attributes_fields) do
      resource[:writeable_attributes]
        .map { |_, p| [p[:field], tmp_model_instance.send(p[:field])] }
        .to_h
    end

    let(:relationships_payload) do
      resource[:writeable_relationships]
        .map do |name, properties|
          [name, { data: { type: properties[:type], id: tmp_model_instance.send(properties[:field]) } }]
        end
        .to_h
    end
    let(:relationships_payload_serialized) { Oj.safe_load(Oj.dump(relationships_payload, mode: :json)) }

    # To check on the created model instance
    let(:relationships_fields) do
      resource[:writeable_relationships]
        .map { |_, p| [p[:field], tmp_model_instance.send(p[:field])] }
        .to_h
    end

    let(:body) do
      Oj.dump({
        data: {
          attributes:    attributes_payload,
          relationships: relationships_payload,
          type:          resource_name,
        },
      }, mode: :json,)
    end

    it 'creates the objects' do
      tmp_model_instance.destroy
      subject

      expect(response.status).to eq 201

      data = jsonapi_response_body[:data]

      expect(data).to be_a Hash
      expect(data[:type]).to eq resource_name.to_s

      # Check response
      attributes_payload_serialized.each do |k, expected_value|
        expect(data[:attributes][k.to_sym]).to eq expected_value
      end

      #relationships_payload_serialized.each do |k, expected_value|
      #  expect(data[:relationships][k.to_sym]).to eq expected_value
      #end

      # Check model instance fields values
      model_instance = resource[:extra][:model_read].find_by(id: data[:id])

      expect(model_instance).not_to be nil

      attributes_fields.each do |field_name, expected_value|
        expect(model_instance.send(field_name)).to eq expected_value
      end

      relationships_fields.each do |field_name, expected_value|
        expect(model_instance.send(field_name)).to eq expected_value
      end
    end

    context 'valid payload' do
      before do
        tmp_model_instance.destroy
        subject
      end

      it_behaves_like 'a valid json:api response'
    end
  end

  resources = KIT_DUMMY_APP_API_CONFIG[:resources]
    .except(:photo) # Because of the polymorphic RS

  resources.each do |_, resource|
    tmp_resource_name = resource[:name]

    context "for #{ tmp_resource_name } resources" do
      let(:resource_name) { tmp_resource_name }
      let(:resource)      { config_dummy_app[:resources][resource_name] }

      it_behaves_like 'returns valid JSON:API data'
    end
  end

end
