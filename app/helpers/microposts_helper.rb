module MicropostsHelper
  def form_options(type)
    form_options_list = []
    if type == "weight"
      start = 20
      diff = 2.5
      finish = 200
    elsif type == "time"
      start = 1
      diff = 1
      finish = 30
    end
    while start <= finish do
      option = []
      option.push(start, start)
      form_options_list << option
      start += diff
    end
    return form_options_list
  end

  def get_dayposts
    today = Time.zone.now
    dayposts = []
    while true
      break if Micropost.where("created_at <= ?", today.end_of_day).count == 0
      daypost = Micropost.where("(created_at >= ?) AND (created_at <= ?)", today.midnight , today.end_of_day).order(:order)
      dayposts << daypost
      today = today.ago(1.days)
    end
    return dayposts
  end

  def get_daypost(date)
    Micropost.where("(created_at >= ?) AND (created_at <= ?)", date.midnight , date.end_of_day).order(:order)
  end

  def get_next_order(date)
    microposts = Micropost.where("(created_at >= ?) AND (created_at <= ?)", date.midnight , date.end_of_day).order(:order)
    microposts.count > 0 ? microposts.last.order+1 : 1
  end

  def get_date(params)
    (params["created_at(1i)"].to_s + "-" + params["created_at(2i)"].to_s + "-" + params["created_at(3i)"].to_s).to_date
  end

  def is_not_future?(micropost)
    micropost.created_at.end_of_day < Time.zone.now.since(1.days).midnight
  end

  def neither_first_nor_last?(micropost, direction)
    microposts = get_daypost(micropost.created_at)
    !((micropost == microposts.last && direction == 1) || (micropost == microposts.first && direction == -1))
  end

  def change_order(micropost_specified, direction)
    microposts_should_change = get_daypost(micropost_specified.created_at).find_by(order: micropost_specified.order+direction)
    micropost_specified.order += direction
    microposts_should_change.order -= direction
    micropost_specified.save
    microposts_should_change.save
  end
end
