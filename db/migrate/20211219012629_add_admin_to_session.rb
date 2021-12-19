class AddAdminToSession < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :admin, :boolean, default: false
  end
end
