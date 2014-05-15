class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :tiebreaker, :integer
    add_column :users, :score, :integer, default: 0, null: false
    add_column :users, :paid, :integer, default: 0, null: false
    add_column :users, :rank, :integer, default: 0, null: false
    add_column :users, :group_rank, :integer, default: 0, null: false
  end
end
