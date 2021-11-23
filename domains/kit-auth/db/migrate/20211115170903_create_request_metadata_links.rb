class CreateRequestMetadataLinks < ActiveRecord::Migration[6.1]

  def change
    create_table   :request_metadata_links do |t|
      t.timestamps                                 null: false
      t.datetime   :deleted_at,       index: true, default: nil

      t.references :request_metadata, index: true, null: false, foreign_key: true
      t.references :target_object,    index: true, null: false, polymorphic: true

      t.text       :category,                      default: nil
    end
  end

end
