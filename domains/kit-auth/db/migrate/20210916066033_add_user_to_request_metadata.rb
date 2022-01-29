class AddUserToRequestMetadata < ActiveRecord::Migration[6.1] # rubocop:disable Style/Documentation

  def change
    add_reference :request_metadata, :user, index: true, foreign_key: true
  end

end
