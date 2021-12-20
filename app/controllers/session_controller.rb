class SessionController < ApplicationController
  PASSWORD_DIGEST = ENV["PASSWORD_DIGEST"]
  PASSWORD_READONLY_DIGEST = ENV["PASSWORD_READONLY_DIGEST"]
  #before_action :destroy_old_session, [:new]
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
      #get_old_session.destroy_all
    end
end