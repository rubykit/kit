# Exemple type for dummy app.
class Kit::Auth::Resources::Api::UserAuth < Kit::Auth::Resources::Api::Resource

  def self.name
    :user_auth
  end

  def self.model_read
    Kit::Auth::Models::Read::User
  end

  def self.model_write
    Kit::Auth::Models::Write::User
  end

  def self.fields_setup
    {
      id:         { type: :id_numeric, sort_field: { default: true, tie_breaker: true } },
      created_at: { type: :date },
      updated_at: { type: :date },
    }
  end

=begin
  def self.relationships
    {
      user_emails: {
        resource:          :user_email,
        relationship_type: :to_many,
        resolvers:         [:active_record, child_field: :id],
      },
    }
  end
=end

  def self.writeable_attributes
    {}
  end

end
