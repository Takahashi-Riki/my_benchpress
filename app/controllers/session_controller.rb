class SessionController < ApplicationController
  PASSWORD_DIGEST = ENV["PASSWORD_DIGEST"]
  SESSION_TOKEN = ENV["SESSION_TOKEN"]
  SESSION_DIGEST = ENV["SESSION_DIGEST"]

  def new

  end

  def create
    password_token = params[:password]
    if authenticated?(password_token, "$2a$12$nyUIK7/vfhDRCsn9Cgmi5ONJ59fVzY1fM45OOXF7ozanPIAvEccXi")
      log_in
      redirect_to root_url
    else
      flash[:notice] = password_token
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
