class AddWinningValueToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :winning_value, :decimal
  end
end
