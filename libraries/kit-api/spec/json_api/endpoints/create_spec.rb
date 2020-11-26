require_relative '../../rails_helper'

describe 'Json:Api Show requests', type: :request do
  include_context 'config dummy app'
  include_context 'json:api'
  include_context 'url'

  let(:subject) { post request_path, headers: jsonapi_headers, params: body }

  let(:write_attributes) do
    {
      author: {
        before: {
          name:          Faker::Book.author,
          date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 65),
        },
        after: ->(before:) do
          before.slice(:name).merge(date_of_birth: before[:date_of_birth].strftime('%Y-%m-%d'))
        end,
      },
    }
  end

  shared_examples 'returns valid JSON:API data' do
    let(:route_id) { "specs|api|#{ resource_name }|create" }

    let(:query_params) do
      { include: '' }
    end

    let(:attributes_before) { write_attributes[resource_name][:before] }
    let(:attributes_after) do
      write_attributes[resource_name][:after].call(before: attributes_before)
    end

    let(:body) do
      Oj.dump({
        data: {
          attributes: attributes_before,
          type:       resource_name,
        },
      }, mode: :json)
    end

    before { subject }

    it 'creates the objects' do
      expect(response.status).to eq 201

      data = jsonapi_response_body[:data]

      expect(data).to be_a Hash
      expect(data[:type]).to eq resource_name.to_s

      attributes_after.each do |k, v|
        expect(data[:attributes][k]).to eq v
      end
    end

    #it_behaves_like 'a valid json:api response'
  end

  whitelist = [:author]

  KIT_DUMMY_APP_API_CONFIG[:resources].each do |_, resource|
    tmp_resource_name = resource[:name]
    next if !whitelist.include?(tmp_resource_name)

    context "for #{ tmp_resource_name } resources" do
      let(:resource_name) { tmp_resource_name }

      it_behaves_like 'returns valid JSON:API data'
    end
  end

end
