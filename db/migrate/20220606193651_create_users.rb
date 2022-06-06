class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.boolean :locked, default: false
      t.integer :failed, default: 0

      t.timestamps
    end
  end
end
