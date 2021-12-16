class MicropostsController < ApplicationController
  before_action :check_login

  def index
    @micropost = Micropost.new
    @microposts = Micropost.all
    @dayposts = get_dayposts(Micropost.all)
  end

  def create
    @micropost = Micropost.new(micropost_params)
    if @micropost.save
      flash[:notice] = "saved!"
      redirect_to root_path
    else
      render "index"
    end
  end

  def destroy
    Micropost.find_by(params[:id]).destroy
    redirect_to microposts_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:weight, :time, :comment)
    end

    def check_login
      redirect_to login_path if !logged_in?
    end
end
