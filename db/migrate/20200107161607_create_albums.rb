class CreateAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :albums do |t|
      t.string :title
      t.string :cover
      t.integer :artist_id
      t.string :genre
      t.integer :nb_tracks
      t.string :label

      t.timestamps
    end
  end
end
