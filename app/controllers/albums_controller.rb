class AlbumsController < ApplicationController

    def index
        albums = Album.all
        render json: albums
    end

    def create 
        puts params
        # byebug
        albums = params['albums'].map{|a|
            
            
            album = Album.find_or_create_by(title: a["album"]["title"], cover: a["album"]["cover"], artist_name: a["artist"])
            artist = Artist.find_by(name: album.artist_name)
            album.update(artist_id: artist.id)
        }
        # album = Album.find_or_create_by(title: album_params['title'], cover: album_params['cover'])
        # byebug
        # artist = Artist.find_by(name: album_params['artist'])
        # album.update(artist_id: artist.id)
        byebug
        render json: albums.as_json()
        
    end

    private

    def album_params
        params.require(:album).permit(:title, :cover, :artist)

    end


end
