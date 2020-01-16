class User < ApplicationRecord
    has_many :album_reviews
    has_many :song_reviews
    has_many :albums, through:  :album_reviews
    has_many :songs, through:  :song_reviews
    validates_uniqueness_of :username

    
end
