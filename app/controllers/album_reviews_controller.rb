class AlbumReviewsController < ApplicationController

    def index 
        reviews = AlbumReviews.all
        render json: reviews.as_json
    end

    def create
        review = AlbumReview.create(album_id: params["review"]["album_id"], user_id: params["id"], rating: params["review"]["rating"], content: params["review"]["review"])
        error = ''
        
        if(!review.id)
            error = "You've already reviewed this album!"
        elsif
            album = Album.find(params["review"]["album_id"])
            album.find_avg_rating
            artist= album.artist 
            artist.find_avg_rating
        end
        albums = Album.all
        artists = Artist.all
        topRatedAlbums = Album.highest_rated
        topRatedArtists = Artist.highest_rated
        reviews = AlbumReview.all
        render json: {
            reviews: reviews,
            albums: albums,
            artists: artists,
            topRatedAlbums: topRatedAlbums,
            topRatedArtists: topRatedArtists, 
            error: error
        }
    end
end
