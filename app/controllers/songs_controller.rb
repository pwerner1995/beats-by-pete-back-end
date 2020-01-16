class SongsController < ApplicationController

    def index
        songs = Song.all.sort{|a,b| [ a.album_name, a.artist_name] <=> [b.album_name, b.artist_name]}
        render json: songs
    end

    def create 
        
        # puts params
    end

end
