class AddAvgRatingToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :avg_rating, :integer
  end
end
