# frozen_string_literal: true

class CreateCatalogSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :catalog_settings do |t|
      t.boolean :show_product_values, null: false, default: true

      t.timestamps
    end
  end
end
