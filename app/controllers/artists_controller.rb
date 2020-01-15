class ArtistsController < ApplicationController

    def index
        artists = Artist.all
        render json: artists
    end

    def create
        artists = params["songs"].map{|a|
            artist = Artist.create(name: a["artist"]["name"], picture: a["artist"]["picture"])
            artist
        }

        albums = params["songs"].map{|a|
            album = Album.create(title: a["album"]["title"], cover: a["album"]["cover"], artist_name: a["artist"]["name"])
            artist = Artist.find_by(name: a["artist"]["name"])
            album.update(artist_id: artist.id)
            album
        }

        songs = params["songs"].map{|a|
            song = Song.create(title: a["title"], preview: a["preview"], album_cover: a["album"]["cover"], artist_name: a["artist"]["name"], duration: a["duration"])
            album = Album.find_by(title: a["album"]["title"])
            song.update(album_id: album.id)
            song
        }
        
        artists.uniq!{|a| a.name}
        albums.uniq!{|a| a.title}
        songs.uniq!{|s| s.title}
        # artists = params["artists"].map{|a|
            
        #     Artist.find_or_create_by(name: a["name"], picture: a["picture"])
        # }
        # # artist = Artist.find_or_create_by(artist_params)
        # artists.uniq!
        render json: {artists: artists, albums: albums, songs: songs}.as_json()
        # puts params
    end

    private

    def artist_params
        params.require(:artist).permit(:name, :picture)
    end


end
