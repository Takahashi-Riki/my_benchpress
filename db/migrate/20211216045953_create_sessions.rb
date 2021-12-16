class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions do |t|
      t.string :digest, null: false

      t.timestamps
    end
  end
end
