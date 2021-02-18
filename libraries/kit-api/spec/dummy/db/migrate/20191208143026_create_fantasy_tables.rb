# Migration to create Fantasy Books data testing set
class CreateFantasyTables < ActiveRecord::Migration[6.0]

  # @note: source https://github.com/endpoints/fantasy-database/blob/ededc366b7586eb575bc2d473221cd303ee27412/ruby/migrate.rb
  def change

    create_table :kit_json_api_spec_authors, id: :serial do |t|
      t.timestamps

      t.text       :name,          null: false
      t.date       :date_of_birth, null: false
      t.date       :date_of_death
    end

    create_table :kit_json_api_spec_photos, id: :serial do |t|
      t.timestamps

      t.references :imageable, polymorphic: true, index: { name: 'index_kjas_photos_on_imageable_type_and_imageable_id' }
      t.text       :title,     null: false
      t.text       :uri,       null: false
    end

    create_table :kit_json_api_spec_series, id: :serial do |t|
      t.timestamps

      # NOTE: pretty sure this was a mistake given the data.
      #t.references :kit_json_api_spec_photo, foreign_key: true, index: true
      t.text :title
    end

    create_table :kit_json_api_spec_books, id: :serial do |t|
      t.timestamps

      t.references :kit_json_api_spec_author, foreign_key: true, index: true
      t.references :kit_json_api_spec_serie,  foreign_key: true, index: true
      t.text       :title,                    null: false
      t.date       :date_published,           null: false
    end

    create_table :kit_json_api_spec_chapters, id: :serial do |t|
      t.timestamps

      t.references :kit_json_api_spec_book, foreign_key: true, index: true
      t.text       :title,                  null: false
      # NOTE: The name is not the same as the one exposed on purpose
      t.integer    :index,                  null: false
    end

    create_table :kit_json_api_spec_stores, id: :serial do |t|
      t.timestamps

      t.text :name, null: false
    end

    create_table :kit_json_api_spec_books_stores, id: :serial do |t|
      t.timestamps

      t.references :kit_json_api_spec_book,  null: false, foreign_key: true, index: { name: :index_kjas_books_stores_on_kjas_book_id }
      t.references :kit_json_api_spec_store, null: false, foreign_key: true, index: { name: :index_kjas_books_stores_on_kjas_store_id }

      # NOTE: this here to illustrate many_to_many when the join table holds actionable data
      t.boolean    :in_stock
    end

  end

end
