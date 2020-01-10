class AddAlbumNameToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :album_name, :string
  end
end
