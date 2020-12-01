require_relative '../../rails_helper'

describe 'Json:Api UPDATE requests', type: :request do
  include_context 'config dummy app'
  include_context 'json:api'
  include_context 'url'

  let(:subject) { patch request_path, headers: jsonapi_headers, params: body }

  shared_examples 'returns valid JSON:API data' do
    let(:route_id) { "specs|api|#{ resource_name }|update" }
    let(:route_params) do
      { resource_id: model_instance.id }
    end

    let(:model_instance) { FactoryBot.create(resource_name) }
    let(:tmp_model_instance) do
      tmp_instance = nil
      safety_exit = 0
      Kernel.loop do
        tmp_instance = FactoryBot.build(resource_name)
        different = resource[:writeable_attributes]
          .map do |name, properties|
            field = properties[:field]
            model_instance.send(field) == nil || model_instance.send(field) != tmp_instance.send(field)
          end
          .uniq

        if different == [true]
          break
        else
          safety_exit += 1
          break if safety_exit > 10
        end
      end

      tmp_instance.save
      tmp_instance
    end

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

    it 'updates the object' do
      subject

      expect(response.status).to eq 200

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
      model_instance.reload

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
    # Photo: Because of the polymorphic RS
    # BookStore: in store is constant in the factory
    .reject { |k, _v| [:photo, :book_store].include?(k) }

  resources.each do |_, resource|
    tmp_resource_name = resource[:name]

    context "for #{ tmp_resource_name } resources" do
      let(:resource_name) { tmp_resource_name }
      let(:resource)      { config_dummy_app[:resources][resource_name] }

      it_behaves_like 'returns valid JSON:API data'
    end
  end

end
