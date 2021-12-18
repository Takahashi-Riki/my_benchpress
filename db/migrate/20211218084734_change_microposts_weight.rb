class ChangeMicropostsWeight < ActiveRecord::Migration[6.0]
  def change
    change_column :microposts, :weight, :float
  end
end
