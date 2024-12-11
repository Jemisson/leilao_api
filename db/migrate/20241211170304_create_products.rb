class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :lot_number
      t.string :donor_name
      t.string :donor_phone
      t.decimal :minimum_value
      t.string :bidder_name
      t.string :bidder_phone
      t.decimal :winning_value
      t.string :description

      t.timestamps
    end
  end
end
