class Kit::Auth::Resources::UserAuth < Kit::JsonApiSpec::Resources::Resource

  def self.name
    :user
  end

  def self.model
    Kit::Auth::Models::Read::User
  end

  def self.fields_setup
    {
      id:             { type: :id_numeric, sort_field: { default: true, tie_breaker: true } },
      created_at:     { type: :date },
    }
  end

=begin
  def self.relationships
    {
      user_sessions: {
        resource:          :auth_token,
        relationship_type: :to_many,
        resolvers:         [:active_record, child_field: :kit_json_api_spec_author_id],
      },
    }
  end
=end

end
