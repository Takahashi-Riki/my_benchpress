module SessionHelper
  SALT = ENV["SALT"]

  def get_digest(string)
    string_digest = Digest::MD5.hexdigest(string)
    salt_digest = Digest::MD5.hexdigest(SALT)
    Digest::MD5.hexdigest(string_digest + salt_digest)
  end

  def new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated?(token, digest)
    digest == get_digest(token)
  end

  def log_in(login_as_admin)
    session_token = new_token
    session_obj = Session.create(digest: get_digest(session_token), admin: login_as_admin)
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

  def admin?
    Session.find(session[:id]).admin
  end

  def log_out
    current_session.destroy if logged_in?
    session.delete(:token)
    session.delete(:id)
  end
end
