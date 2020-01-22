class User < ApplicationRecord
    has_many :album_reviews
    has_many :song_reviews
    has_many :albums, through:  :album_reviews
    has_many :songs, through:  :song_reviews
    validates_uniqueness_of :username

    def last_five_reviews
        reviews = self.album_reviews
        last_five = []
        i = 1
        if(reviews.count > 4)
            last_five = [reviews[reviews.count-1], reviews[reviews.count-2], reviews[reviews.count-3], reviews[reviews.count-4], reviews[reviews.count-5]]
        else 
            last_five = reviews
        end
        last_five
    end

    def favorites
        reviews = self.album_reviews.sort{|a,b| b.rating.to_f <=> a.rating.to_f}
        fav_albums = []
        reviews.each{|review|
            if(!fav_albums.include?(review.album_id))
                fav_albums.push(review.album_id)
            end
        }
        fav_albums.map!{|id| Album.find(id)}
        fav_albums.each{|a| a.find_avg_rating}
        fav_artists = self.top_three_artists(fav_albums)
        if(fav_albums.count >3)
            fav_albums = [fav_albums[0], fav_albums[1], fav_albums[2]]
        end
        favs = {
            albums: fav_albums,
            artists: fav_artists
        }
        favs


    end

    def top_three_artists(albums)
        artists = []
        albums.each{|album|
            artist = Artist.find(album.artist_id)
            if(!artists.include?(artist))
                artists.push(artist)
            end
        }
        if(artists.count >3)
            artists = [artists[0], artists[1], artists[2]]
        end
        artists.each{|a| a.find_avg_rating}
        artists

    end

end
