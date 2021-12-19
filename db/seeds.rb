times_list = [1, 3, 5, 10, 15]

10.times do |i|
  10.times do |k|
    micropost = Micropost.create(weight: 60+i, time: times_list[i%5], comment: "あ"*i, order:k)
    micropost.created_at = Time.zone.now.ago(i.days)
    micropost.save
  end
end