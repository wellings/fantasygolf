class CreateGolfers < ActiveRecord::Migration
  def change
    create_table :golfers do |t|
      t.string :first_name
      t.string :last_name
      t.integer :score
      t.integer :thru
      t.integer :rank
      t.integer :web_id

      t.timestamps
    end
  end
end
