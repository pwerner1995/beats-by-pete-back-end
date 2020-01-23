class AddLgPictureToArtists < ActiveRecord::Migration[6.0]
  def change
    add_column :artists, :lg_picture, :string
  end
end
