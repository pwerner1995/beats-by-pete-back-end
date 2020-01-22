class User < ApplicationRecord
    has_many :album_reviews
    has_many :song_reviews
    has_many :albums, through:  :album_reviews
    has_many :songs, through:  :song_reviews
    validates_uniqueness_of :username

    def last_five_reviews
        reviews = []
        i = 1
        while i < 6
            reviews.push(self.album_reviews[self.album_reviews.count - i])
            i += 1
        end
        reviews
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
        fav_albums = [fav_albums[0], fav_albums[1], fav_albums[2]]
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
    
        artists = [artists[0], artists[1], artists[2]]
        artists.each{|a| a.find_avg_rating}
        artists

    end

end
