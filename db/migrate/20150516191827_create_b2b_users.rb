class CreateB2bUsers < ActiveRecord::Migration
  def change
    create_table :b2b_users do |t|
      t.string :username
      t.string :password

      t.timestamps null: false
    end
  end
end
