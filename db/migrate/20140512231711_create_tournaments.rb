class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.string :year
      t.string :web_id
      t.boolean :active
      t.datetime :date

      t.timestamps
    end
  end
end
