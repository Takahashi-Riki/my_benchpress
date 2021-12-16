class CreateMicroposts < ActiveRecord::Migration[6.0]
  def change
    create_table :microposts do |t|
      t.integer :weight, null: false
      t.integer :time, null: false
      t.string :comment
      t.timestamps
    end
  end
end
