class Song < ApplicationRecord
    belongs_to :album
    validates_uniqueness_of :title
    has_many :users, through: :song_reviews

    def self.search(params)
        self.where('title LIKE ? ', "%#{params["searchTerms"]["song"]}%")
    end

end
