class CreateKitJsonApiSpecComments < ActiveRecord::Migration[6.0]

  def change
    create_table :kit_json_api_spec_comments do |t|
      t.timestamps                    null: false
      t.string     :text, index: true, null: false
      t.references :kit_json_api_spec_post
      t.references :kit_json_api_spec_user
    end
  end

end
