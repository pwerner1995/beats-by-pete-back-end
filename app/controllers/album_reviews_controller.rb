class AlbumReviewsController < ApplicationController

    def index 
        reviews = AlbumReview.all
        render json: reviews.as_json
    end

    def delete
        review = AlbumReview.find(params["review"]["id"])
        user = User.find(review.user_id)
        review.destroy
        recent_reviews = user.last_five_reviews
        favs = user.favorites
        
        render json: {
            user: user,
            favs: favs,
            recent_reviews: recent_reviews
        }
    end

    def create
        review = AlbumReview.create(album_id: params["review"]["album_id"], user_id: params["id"], rating: params["review"]["rating"], content: params["review"]["review"])
        error = ''
        album = Album.find(params["review"]["album_id"])
        album.find_avg_rating
        artist= album.artist 
        artist.find_avg_rating
        albums = Album.all
        artists = Artist.all
        reviews = AlbumReview.all
        user = User.find(params["id"])
        recent_reviews = user.last_five_reviews
        favs = user.favorites
        albumSearchResults = params["albumSearchResults"].map{|a| Album.find(a["id"])}
        artistSearchResults = params["artistSearchResults"].map{|a| Artist.find(a["id"])}
        albumSearchResults = albumSearchResults.each{|a| a.find_avg_rating}
        artistSearchResults = artistSearchResults.each{|a| a.find_avg_rating}
        albumSearchResults = albumSearchResults.sort{|a,b| [b.avg_rating.to_f, b.artist_name] <=> [a.avg_rating.to_f, a.artist_name]}
        artistSearchResults = artistSearchResults.sort{|a,b| [b.name, b.avg_rating.to_f] <=> [a.name, a.avg_rating.to_f]}
        topRatedAlbums = Album.highest_rated
        topRatedArtists = Artist.highest_rated
        render json: {
            reviews: reviews,
            albums: albums,
            artists: artists,
            recent_reviews: recent_reviews,
            favs: favs,
            albumSearchResults: albumSearchResults,
            artistSearchResults: artistSearchResults,
            topRatedAlbums: topRatedAlbums,
            topRatedArtists: topRatedArtists, 
            error: error
        }
    end
end
