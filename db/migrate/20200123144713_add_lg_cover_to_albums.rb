class AddLgCoverToAlbums < ActiveRecord::Migration[6.0]
  def change
    add_column :albums, :lg_cover, :string
  end
end
