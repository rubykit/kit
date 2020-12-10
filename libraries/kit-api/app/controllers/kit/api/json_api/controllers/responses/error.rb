require 'oj'

# Contains logic related to generating Json:Api error http responses.
module Kit::Api::JsonApi::Controllers::Responses::Error

  # Generates a valid Json:Api error payload.
  #
  # ### References
  # - https://jsonapi.org/examples/#error-objects
  def self.generate_response(errors:, status_code: nil)
    content = {
      errors: errors.map do |error|
        res = {
          detail: error[:detail],
        }

        if error[:status_code]
          res[:status] = error[:status_code].to_s
        end

        if error[:attribute_name]
          res[:title] = 'Invalid Attribute'
        end

        if error[:source]
          res[:source] = error[:source]
        end

        res
      end,
    }

    status_code ||= generate_status_code(content: content)[1][:status_code]

    content_json = content ? ::Oj.dump(content, mode: :json) : nil

    [:ok, {
      router_response: {
        mime:     :json_api,
        content:  content_json,
        metadata: {
          http: {
            status: status_code,
          },
        },
      },
    },]
  end

  # Return status code if unique, or the "most generally applicable" one otherwise.
  #
  # ### References
  # - https://jsonapi.org/format/1.1/#errors-processing
  def self.generate_status_code(content:, default_status_code: nil)
    default_status_code ||= 400

    list = content[:errors]
      .map { |error| error[:status] }
      .compact

    case list.size
    when 0
      status_code = default_status_code
    when 1
      status_code = list[0]
    else
      code, _count = list
        .group_by { |el| el.to_s[0] }
        .max_by   { |_k, v| v.size }

      status_code = "#{ code }00"
    end

    [:ok, status_code: status_code]
  end

end
