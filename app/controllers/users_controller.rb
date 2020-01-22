class UsersController < ApplicationController

    def index
        users = User.all
        render json: users.as_json
    end

    def show
        user = User.find(params["id"])
        recent_reviews = user.last_five_reviews
        favs = user.favorites

        render json: {
            user: user,
            favs: favs,
            recent_reviews: recent_reviews
        }
    end

    def create
        byebug
    end

end
