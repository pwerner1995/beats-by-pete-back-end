class ArtistsController < ApplicationController

    def index
        artists = Artist.all.sort_by{|a| a.name} 
        topRatedArtists = Artist.highest_rated
        render json: {
            artists: artists,
            topRatedArtists: topRatedArtists
        }
    end

    def create
        params["songs"].each{|a|
            artist = Artist.find_by(name: a["artist"]["name"])
            if(!artist)
                artist = Artist.find_or_create_by(name: a["artist"]["name"], picture: a["artist"]["picture_medium"], avg_rating: 0.0)
            end
        }

        params["songs"].each{|a|
            album = Album.find_by(title: a["album"]["title"])
            if(!album)
                album = Album.find_or_create_by(title: a["album"]["title"], cover: a["album"]["cover_medium"], artist_name: a["artist"]["name"], avg_rating: 0.0)
                artist = Artist.find_by(name: a["artist"]["name"])
                album.update(artist_id: artist.id)
            end
        }

        params["songs"].each{|a|
            song = Song.find_by(title: a["title"])    
            if(!song)
                song = Song.find_or_create_by(title: a["title"], preview: a["preview"], album_cover: a["album"]["cover_medium"], artist_name: a["artist"]["name"], duration: a["duration"])
                album = Album.find_by(title: a["album"]["title"])
                song.update(album_id: album.id, album_name: album.title)
            end
        }

        artists = []
        albums = []
        songs = []
        if(params["searchTerms"]["artist"] != "")
            artists = Artist.search(params)
        end

        if(params["searchTerms"]["album"] != "")
            albums = Album.search(params)
        end

        if(params["searchTerms"]["song"] != "")
            songs = Song.search(params)
        end

        if(artists.count < 1 && params["searchTerms"]["artist"] != "")
            artists = Artist.all.filter{|a| a.name.upcase.include?(params["searchTerms"]["artist"].upcase)}
        end

        if(albums.count < 1 && params["searchTerms"]["album"] != "")
            albums = Album.all.filter{|a| a.title.upcase.include?(params["searchTerms"]["album"].upcase)}
        end

        if(songs.count < 1 && params["searchTerms"]["song"] != "")
            songs = Song.all.filter{|a| a.title.upcase.include?(params["searchTerms"]["song"].upcase)}
        end

        if(albums.count > 1 && params["searchTerms"]["artist"] == "")
            albums.each{|album|
                artists.push(album.artist)
            }
        end

        if(songs.count > 1 && (params["searchTerms"]["artist"] == "" || params["searchTerms"]["artist"] == ""))
            songs.each{|song|
                albums.push(song.album)
                artists.push(song.album.artist)
            }
        end

        artists.each{|artist|
            artist.albums.each{|album|
                albums.push(album)
            }
        }

        albums.each{|album|
            album.songs.each{|song|
                songs.push(song)
            }
        }

        if(artists.count > 0)
            artists = artists.uniq{|a| a.name}
            artists = artists.sort{|a,b| [b.name, b.avg_rating.to_f] <=> [a.name, a.avg_rating.to_f]} 
        end
    
        if(albums.count > 0)
            albums = albums.uniq{|a| a.title}
            albums = albums.sort{|a,b| [b.avg_rating.to_f, b.artist_name] <=> [a.avg_rating.to_f, a.artist_name]}
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
