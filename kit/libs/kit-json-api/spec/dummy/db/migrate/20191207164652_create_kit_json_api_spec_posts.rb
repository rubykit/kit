class CreateKitJsonApiSpecPosts < ActiveRecord::Migration[6.0]

  def change
    create_table :kit_json_api_spec_posts do |t|
      t.timestamps                    null: false
      t.string     :url, index: true, null: false
      t.references :kit_json_api_spec_user
    end
  end

end
