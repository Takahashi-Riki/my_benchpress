times_list = [1, 3, 5, 10, 15]

100.times do |i|
  micropost = Micropost.create(weight: 60+i, time: times_list[i%5], comment: "あ"*i)
  micropost.created_at = Time.zone.now.ago((i/4).days)
  micropost.save
end