class AddLinkVideoToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :link_video, :string
  end
end
