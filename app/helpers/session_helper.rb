module SessionHelper
  PASSWORD_DIGEST = ENV["PASSWORD_DIGEST"]
  SESSION_TOKEN = ENV["SESSION_TOKEN"]
  SESSION_DIGEST = ENV["SESSION_DIGEST"]

  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated?(token, digest)
    BCrypt::Password.new(digest).is_password?(token)
  end

  def log_in
    Session.all.destroy_all if Session.all.count > 0
    session_token = new_token
    session_obj = Session.create(digest: digest(session_token))
    session[:id] = session_obj.id
    session[:token] = session_token
  end

  def sessions_exist?
    !session[:id].nil? || !session[:token].nil? || Session.exists?(id: session[:id])
  end

  def current_session
    Session.find(session[:id]) if sessions_exist?
  end

  def logged_in?
    return false if !sessions_exist?
    authenticated?(session[:token], current_session.digest)
  end

  def log_out
    current_session.destroy if logged_in?
    session.delete(:token)
    session.delete(:id)
  end
end
