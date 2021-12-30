class MicropostsController < ApplicationController
  before_action :check_login
  before_action :check_admin, only: [:create, :destroy]

  def index
    @micropost = Micropost.new
    @dayposts = get_dayposts
  end

  def create
    @micropost = Micropost.new(micropost_params)
    date = get_date(micropost_params)
    order = get_next_order(date)
    @micropost.created_at = date
    @micropost.order = order
    if @micropost.save && is_not_future?(@micropost)
      redirect_to root_path
    else
      @dayposts = get_dayposts
      render "index"
    end
  end

  def update
    micropost = Micropost.find(params[:id])
    if params[:direction] == "up"
      direction = -1
    elsif params[:direction] == "down"
      direction = 1
    else
      redirect_to root_path
    end
    exchange_order(micropost, direction) if neither_first_nor_last?(micropost, direction)
    redirect_to root_path
  end

  def destroy
    micropost = Micropost.find(params[:id])
    micropost.destroy
    move_over_order(micropost)
    redirect_to root_path
  end

  private

    def micropost_params
      params.require(:micropost).permit(:weight, :time, :comment, :created_at)
    end

    def check_login
      redirect_to login_path if !logged_in?
    end

    def check_admin
      redirect_to login_path if !admin?
    end
end
