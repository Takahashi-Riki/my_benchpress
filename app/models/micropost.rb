class Micropost < ApplicationRecord
  validates :weight, presence: true
  validates :time, presence: true
  validates :comment, length: { maximum: 100 }
  validates :order, inclusion: { in: (1..100)}
end
