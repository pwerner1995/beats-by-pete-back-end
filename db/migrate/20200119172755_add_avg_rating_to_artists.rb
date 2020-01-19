class AddAvgRatingToArtists < ActiveRecord::Migration[6.0]
  def change
    add_column :artists, :avg_rating, :float
  end
end
