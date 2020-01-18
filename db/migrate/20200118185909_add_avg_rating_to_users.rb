class AddAvgRatingToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :avg_rating, :float
  end
end
