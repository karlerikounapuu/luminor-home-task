module Api
  module V1
    class BaseController < ActionController::API
      include ActionController::HttpAuthentication::Basic::ControllerMethods

      before_action :authenticate

      private

      def authenticate
        authenticate_or_request_with_http_basic do |email, password|
          user = User.find_by(email: email)
          user && user.valid_password?(password)
        end
      end
    end
  end
end
