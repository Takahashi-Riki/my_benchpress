module SessionHelper
  PASSWORD_DIGEST = ENV["PASSWORD_DIGEST"]
  SESSION_TOKEN = ENV["SESSION_TOKEN"]
  SESSION_DIGEST = ENV["SESSION_DIGEST"]

  def digest(string)
    salt = "74b87337454200d4d33f80c4663dc5e5"
    string_digest = Digest::MD5.hexdigest(string)
    salt_digest = Digest::MD5.hexdigest(salt)
    Digest::MD5.hexdigest(string_digest + salt_digest)
  end

  def new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated?(token, digest)
    digest == digest(token)
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
