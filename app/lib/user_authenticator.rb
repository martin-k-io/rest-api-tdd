class UserAuthenticator
  class AuthenticationError < StandardError; end

  attr_reader :authenticator

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
  end

  def user
    authenticator.user
  end

  def access_token
    authenticator.access_token
  end

  private

  def client
    @client ||= Octokit::Client.new(
      client_id: ENV['GITHUB_CLIENT_ID'],
      client_secret: ENV['GITHUB_CLIENT_SECRET']
    )
  end

  def token
    # Accepts the authorization code
    # Returns github access token as a result
    @token ||= client.exchange_code_for_token(@code)
  end

  def user_data
    @user_data ||= Octokit::Client.new(access_token: @token)
      .user.to_h.slice(:login, :name, :url, :avatar_url)
  end

  def prepare_user
    @user = if User.exists?(login: user_data[:login])
      User.find_by(login: user_data[:login])
    else
      User.create(user_data.merge(provider: 'github'))
    end
  end

  attr_reader :code
end