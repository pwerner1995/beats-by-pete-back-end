class SongReview < ApplicationRecord
    belongs_to :user
    belongs_to :song
    validates_uniqueness_of :user_id

end
