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

  def get_dayposts(microposts)
    today = Time.zone.now
    dayposts = []
    while true
      break if Micropost.where("created_at <= ?", today.end_of_day).count == 0
      daypost = Micropost.where("(created_at > ?) AND (created_at <= ?)", today.midnight , today.end_of_day).order(:order)
      dayposts << daypost
      today = today.ago(1.days)
    end
    return dayposts
  end

  def get_order(date)
    microposts = Micropost.where("(created_at > ?) AND (created_at <= ?)", date.midnight , date.end_of_day).order(:order)
    microposts.count > 0 ? microposts.last.order+1 : 1
  end
end
