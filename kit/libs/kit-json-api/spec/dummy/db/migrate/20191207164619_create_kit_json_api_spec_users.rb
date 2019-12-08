class CreateKitJsonApiSpecUsers < ActiveRecord::Migration[6.0]

  def change
    create_table :kit_json_api_spec_users do |t|
      t.timestamps                      null: false
      t.string     :email, index: true, null: false
    end
  end

end
