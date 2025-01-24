class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :lot_number
      t.string :donor_name
      t.string :donor_phone
      t.decimal :minimum_value
      t.string :description
      t.string :sold_at
      t.integer :auctioned, default: 0
      t.timestamps
    end
  end
end
