module Api
  module V1
    class RegistrationsController < ApiController
      # This controller handles user registration
      def create
        # Check if the user is already logged in
        user = User.new(
          email: params[:user][:email],
          password: params[:user][:password],
          password_confirmation: params[:user][:password]
        )

        if user.save
          # Automatically log in the user after registration
          session[:user_id] = user.id
          render json: { status: :success, logged_in: true }, status: 204
        else
          # If registration fails, return errors
          render json: { status: :error, logged_in: false }, status: 422
        end
      end
    end
  end
end
