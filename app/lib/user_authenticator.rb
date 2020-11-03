class UserAuthenticator
  class AuthenticationError < StandardError; end

  attr_reader :authenticator, :access_token

  def initialize(code: nil, login: nil, password: nil)
    @authenticator = if code.present?
      Oauth.new(code)
    else
      Standard.new(login, password)
    end
  end

  def perform
    # Since we have attr_reader :authenticator
    # we can call authenticator instead of @authenticator
    authenticator.perform

    set_access_token
  end

  def user
    authenticator.user
  end
  
  private

  def set_access_token
    @access_token = if user.access_token.present?
      user.access_token
    else
      user.create_access_token
    end
  end
end