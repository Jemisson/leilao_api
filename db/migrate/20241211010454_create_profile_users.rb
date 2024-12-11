class CreateProfileUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :profile_users do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :name
      t.string :cpf
      t.date :birth
      t.string :street
      t.string :number
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :country
      t.string :zip_code

      t.timestamps
    end
  end
end
