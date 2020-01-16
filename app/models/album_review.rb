class AlbumReview < ApplicationRecord
    belongs_to :user
    belongs_to :album
    validates_uniqueness_of :user_id

end
