class CreateSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :songs do |t|
      t.integer :album_id
      t.integer :duration
      t.string :preview
      t.string :title
      t.string :artist_name
      t.string :album_cover

      t.timestamps
    end
  end
end
