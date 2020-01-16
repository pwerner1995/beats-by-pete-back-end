class UsersController < ApplicationController

    def index
        users = User.all
        render json: users.as_json
    end

    def create
        byebug
    end

end
