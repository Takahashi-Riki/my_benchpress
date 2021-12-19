class AddOrderToMicropost < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :order, :integer, null: false
  end
end
