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
            elsif(!artist.lg_picture)
                artist.update(lg_picture: a["artist"]["picture_big"])
            end
        }

        params["songs"].each{|a|
            album = Album.find_by(title: a["album"]["title"])
            if(!album)
                album = Album.find_or_create_by(title: a["album"]["title"], cover: a["album"]["cover_medium"], artist_name: a["artist"]["name"], avg_rating: 0.0)
                artist = Artist.find_by(name: a["artist"]["name"])
                album.update(artist_id: artist.id)
            elsif(!album.lg_cover)
                album.update(lg_cover: a["album"]["cover_big"])
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

        new_artists = []
        new_albums = []
        new_songs = []
        if(params["searchTerms"]["artist"] != "")
            new_artists = Artist.search(params)
        end

        if(params["searchTerms"]["album"] != "")
            new_albums = Album.search(params)
        end

        if(params["searchTerms"]["song"] != "")
            new_songs = Song.search(params)
        end

        if(new_artists.count < 1 && params["searchTerms"]["artist"] != "")
            new_artists = Artist.all.filter{|a| a.name.upcase.include?(params["searchTerms"]["artist"].upcase)}
        end

        if(new_albums.count < 1 && params["searchTerms"]["album"] != "")
            new_albums = Album.all.filter{|a| a.title.upcase.include?(params["searchTerms"]["album"].upcase)}
        end

        if(new_songs.count < 1 && params["searchTerms"]["song"] != "")
            new_songs = Song.all.filter{|a| a.title.upcase.include?(params["searchTerms"]["song"].upcase)}
        end

        if(new_albums.count > 1 && params["searchTerms"]["artist"] == "")
            new_albums.each{|album|
                new_artists.push(album.artist)
            }
        end

        if(new_songs.count > 1 && (params["searchTerms"]["artist"] == "" || params["searchTerms"]["artist"] == ""))
            new_songs.each{|song|
                new_albums.push(song.album)
                new_artists.push(song.album.artist)
            }
        end

        new_artists.each{|artist|
            if(artist.albums)
                artist.albums.each{|album|
                    new_albums.push(album)
                }
            end
        }

        new_albums.each{|album|
            if(album.songs)
                album.songs.each{|song|
                    new_songs.push(song)
                }
            end
        }

        if(new_artists.count > 0)
            new_artists = new_artists.uniq{|a| a.name}
            new_artists = new_artists.sort{|a,b| [b.name, b.avg_rating.to_f] <=> [a.name, a.avg_rating.to_f]} 
        end
    
        if(new_albums.count > 0)
            new_albums = new_albums.uniq{|a| a.title}
            new_albums = new_albums.sort{|a,b| [b.avg_rating.to_f, b.artist_name] <=> [a.avg_rating.to_f, a.artist_name]}
        end
        if(new_songs.count > 0)
            new_songs = new_songs.uniq{|s| s.title}
            new_songs = new_songs.sort{|a,b| [ b.album.avg_rating.to_f] <=> [a.album.avg_rating.to_f]}
            
        end

        # artists = params["artists"].map{|a|
            
        #     Artist.find_or_create_by(name: a["name"], picture: a["picture"])
        # }
        # # artist = Artist.find_or_create_by(artist_params)
        # artists.uniq!
        render json: {
            searchArtists: new_artists, 
            searchAlbums: new_albums, 
            searchSongs: new_songs,
            artists: Artist.all, 
            albums: Album.all, 
            songs: Song.all}.as_json()
        # puts params
    end

    private

    def artist_params
        params.require(:artist).permit(:name, :picture)
    end


end
