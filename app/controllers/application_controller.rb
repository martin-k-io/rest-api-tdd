class ApplicationController < ActionController::API
  class AuthorizationError < StandardError; end

  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error
  rescue_from AuthorizationError, with: :authorization_error

  # All resources requiring authorization approach
  # instead of all accessible but only specific ones authorizable
  before_action :authorize!

  private

  def authorize!
    raise AuthorizationError unless current_user
  end

  def access_token
    # request is an Object accesible in all controllers 
    # having a method authoirzation returning the value
    # of the request header with the same name

    # If the authentication is invalid, use safe operator &
    # to return nil instead of raising an exception
    provided_token = request.authorization&.gsub(/\ABearer\s/, '')
    @access_token = AccessToken.find_by(token: provided_token)
  end

  def current_user
    @current_user = access_token&.user
  end

  def authentication_error
    error = {
      "status" => "401",
      "source" => { "pointer" => "/code" },
      "title" => "Authentication code is invalid",
      "detail" => "You must provide valid code in order to exchange it for token."
    }
    render json: { "errors": [ error ]}, status: 401
  end

  def authorization_error
    error = {
      "status" => "403",
      "source" => { "pointer" => "/headers/authorization" },
      "title" => "Not authorized",
      "detail" => "You have no right to access this resource."
    }
    render json: { "errors": [ error ] }, status: 403
  end
end
