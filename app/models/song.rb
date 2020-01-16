class Song < ApplicationRecord
    belongs_to :album
    validates_uniqueness_of :title
    has_many :users, through: :song_reviews


end
