class AddNotesToBids < ActiveRecord::Migration[7.1]
  def change
    add_column :bids, :notes, :string
  end
end
