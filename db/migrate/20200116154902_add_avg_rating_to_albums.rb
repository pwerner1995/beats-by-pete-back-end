class AddAvgRatingToAlbums < ActiveRecord::Migration[6.0]
  def change
    add_column :albums, :avg_rating, :float
  end
end
