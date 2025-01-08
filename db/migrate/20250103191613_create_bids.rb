class CreateBids < ActiveRecord::Migration[7.1]
  def change
    create_table :bids do |t|
      t.references :profile_user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.decimal :value

      t.timestamps
    end
  end
end
