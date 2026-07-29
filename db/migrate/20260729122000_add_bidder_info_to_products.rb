# frozen_string_literal: true

class AddBidderInfoToProducts < ActiveRecord::Migration[7.1]
  def change
    change_table :products, bulk: true do |t|
      t.string :bidder_name
      t.string :bidder_phone
    end
  end
end
