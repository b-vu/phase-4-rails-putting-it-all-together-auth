class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

    def create
        user = User.create!(users_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end

    def show
        user = User.find_by(id: session[:user_id])
        if user
            render json: user, status: :created
        else
            render json: { error: "User not authorized" }, status: :unauthorized
        end
    end

    private

    def users_params
        params.permit(:username, :password, :password_confirmation, :image_url, :bio)
    end

    def render_unprocessable_entity(exception)
        render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
    end
end