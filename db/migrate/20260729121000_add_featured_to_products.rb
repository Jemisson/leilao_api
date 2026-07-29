# frozen_string_literal: true

class AddFeaturedToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :featured, :boolean, null: false, default: false
    add_index :products, %i[featured updated_at]
  end
end
