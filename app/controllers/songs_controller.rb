class SongsController < ApplicationController

    def index
        songs = Song.all.sort{|a,b| [ a.album_name, a.artist_name] <=> [b.album_name, b.artist_name]}
        treats = [Song.find(2), Song.find(108), Song.find(390), Song.find(1), Song.find(320), Song.find(421), Song.find(109), Song.find(139), Song.find(74), Song.find(182), Song.find(418), Song.find(137), Song.find(360), Song.find(64), Song.find(413)]

        render json: {
            songs: songs,
            treats: treats
        }
    end

    def create 
        
        # puts params
    end

end
