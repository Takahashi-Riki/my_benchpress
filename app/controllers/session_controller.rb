class SessionController < ApplicationController
  PASSWORD_DIGEST = ENV["PASSWORD_DIGEST"]
  PASSWORD_READONLY_DIGEST = ENV["PASSWORD_READONLY_DIGEST"]
  before_action :destroy_old_session, only: [:new]
  before_action :check_not_login, only: [:new, :create]

  def new
    
  end

  def create
    login_as_admin = !(params[:password].nil?)
    password_token = login_as_admin ? params[:password] : params[:password_readonly]
    password_digest = login_as_admin ? PASSWORD_DIGEST : PASSWORD_READONLY_DIGEST
    if authenticated?(password_token, password_digest)
      log_in(login_as_admin)
      redirect_to root_url
    else
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

    def check_not_login
      redirect_to root_path if logged_in?
    end

    def destroy_old_session
      sessions = Session.all
      sessions.each do |session|
        if session.created_at < Time.zone.now.ago(1.days)
          session.destroy
        end
      end
    end
end