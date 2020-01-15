class SongsController < ApplicationController

    def index
        songs = Song.all
        render json: songs
    end

    def create 
        
        # puts params
    end

end
