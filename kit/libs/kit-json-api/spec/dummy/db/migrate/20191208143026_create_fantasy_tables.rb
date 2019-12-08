class CreateFantasyTables < ActiveRecord::Migration[6.0]

  # @note: source https://github.com/endpoints/fantasy-database/blob/ededc366b7586eb575bc2d473221cd303ee27412/ruby/migrate.rb
  def change

    create_table   :kit_json_api_spec_authors do |t|
      t.timestamps

      t.text       :name,          null: false
      t.date       :date_of_birth, null: false
      t.date       :date_of_death
    end

    create_table   :kit_json_api_spec_photos do |t|
      t.timestamps

      t.references :imageable, polymorphic: true, index: { name: 'index_kjas_photos_on_imageable_type_and_imageable_id' }
      t.text       :title,     null: false
      t.text       :uri,       null: false
    end

    create_table   :kit_json_api_spec_series do |t|
      t.timestamps

      # NOTE: pretty sure this was a mistake given the data.
      #t.references :kit_json_api_spec_photo, foreign_key: true, index: true
      t.text       :title
    end

    create_table   :kit_json_api_spec_books do |t|
      t.timestamps

      t.references :kit_json_api_spec_author, foreign_key: true, index: true
      t.references :kit_json_api_spec_serie,  foreign_key: true, index: true
      t.text       :title,                    null: false
      t.date       :date_published,           null: false
    end

    create_table   :kit_json_api_spec_chapters do |t|
      t.timestamps

      t.references :kit_json_api_spec_book, foreign_key: true, index: true
      t.text       :title,                  null: false
      # The name is not the same as the one exposed on purpose
      t.integer    :index,                  null: false
    end

    create_table   :kit_json_api_spec_stores do |t|
      t.timestamps

      t.text       :name, null: false
    end

    create_table   :kit_json_api_spec_books_stores do |t|
      t.references :kit_json_api_spec_book,  null: false, foreign_key: true, index: { name: :index_kjas_books_stores_on_kjas_book_id }
      t.references :kit_json_api_spec_store, null: false, foreign_key: true, index: { name: :index_kjas_books_stores_on_kjas_store_id }
    end

  end

end
