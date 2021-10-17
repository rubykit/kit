# Exemple type for dummy app.
class Kit::Auth::Resources::Api::UserEmail < Kit::Auth::Resources::Api::Resource

  def self.name
    :user_email
  end

  def self.model_read
    Kit::Auth::Models::Read::User
  end

  def self.model_write
    Kit::Auth::Models::Write::User
  end

  def self.fields_setup
    {
      id:           { type: :id_numeric, sort_field: { default: true, tie_breaker: true } },
      created_at:   { type: :date },
      updated_at:   { type: :date },

      email:        { type: :string },
      confirmed_at: { type: :date },
      primary:      { type: :bool },
    }
  end

  def self.relationships
    {}
  end

  def self.writeable_attributes
    {}
  end

end
