class Micropost < ApplicationRecord
  validates :weight, presence: true
  validates :time, presence: true
  validates :comment, length: { maximum: 100 }
  default_scope -> { order(created_at: :asc) }
end
