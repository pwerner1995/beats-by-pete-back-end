class ArtistsController < ApplicationController

    def index
        artists = Artist.all.sort_by{|a| a.name} 
        render json: artists
    end

    def create
        artists = params["songs"].map{|a|
            artist = Artist.find_by(name: a["artist"]["name"])
            if(!artist)
                artist = Artist.find_or_create_by(name: a["artist"]["name"], picture: a["artist"]["picture_medium"])
            end
            artist
        }

        albums = params["songs"].map{|a|
            album = Album.find_by(title: a["album"]["title"])
            if(!album)
                album = Album.find_or_create_by(title: a["album"]["title"], cover: a["album"]["cover_medium"], artist_name: a["artist"]["name"])
                artist = Artist.find_by(name: a["artist"]["name"])
                album.update(artist_id: artist.id)
            end
            album
        }

        songs = params["songs"].map{|a|
            song = Song.find_by(title: a["title"])    
            if(!song)
                song = Song.find_or_create_by(title: a["title"], preview: a["preview"], album_cover: a["album"]["cover_medium"], artist_name: a["artist"]["name"], duration: a["duration"])
                album = Album.find_by(title: a["album"]["title"])
                song.update(album_id: album.id, album_name: album.title)
            end
            song
        }
        if(artists.count > 0)
            artists = artists.uniq{|a| a.name}
            artists = artists.sort_by{|a| a.name} 
        end
    
        if(albums.count > 0)
            albums = albums.uniq{|a| a.title}
            albums = albums.sort_by{|a| a.artist_name}
        end
        if(songs.count > 0)
            songs = songs.uniq{|s| s.title}
            songs = songs.sort{|a,b| [ a.album_name, a.artist_name] <=> [b.album_name, b.artist_name]}
            
        end
        # artists = params["artists"].map{|a|
            
        #     Artist.find_or_create_by(name: a["name"], picture: a["picture"])
        # }
        # # artist = Artist.find_or_create_by(artist_params)
        # artists.uniq!
        render json: {searchArtists: artists, searchAlbums: albums, searchSongs: songs, artists: Artist.all, albums: Album.all, songs: Song.all}.as_json()
        # puts params
    end

    private

    def artist_params
        params.require(:artist).permit(:name, :picture)
    end


end
