class Artist < ApplicationRecord
    has_many :albums
    validates_uniqueness_of :name

    def find_avg_rating
        albums = self.albums
        reviews = 0
        sum =0
        albums.each{|album|
            sum+=(album.avg_rating * album.album_reviews.count)
            reviews += album.album_reviews.count
        }
        
        if(reviews > 0)
            new_avg = sum/reviews
        else
            new_avg = 0.0
        end
        self.update(avg_rating: new_avg.round(2))
    end

    def self.search(params)
        self.where('name LIKE ?', "%#{params["searchTerms"]["artist"]}%")
    end

    def self.highest_rated
        sorted = Artist.all.sort{|a, b| b.avg_rating.to_f <=> a.avg_rating.to_f}
        top12 = []
        i = 0
        while(i < 12)
            top12.push(sorted[i])
            i += 1
        end
        top12
    end
end
