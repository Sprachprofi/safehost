class CreateHosts < ActiveRecord::Migration[6.0]
  def change
    create_table :hosts do |t|
      t.integer :user_id
      t.text :address
      t.string :postal_code, limit: 20
      t.string :city, limit: 50
      t.string :country, limit: 2
      t.integer :optimal_no_guests
      t.integer :max_sleeps
      t.integer :max_duration
      t.string :sleep_conditions
      t.string :which_guests
      t.string :which_hosts
      t.text :description
      t.string :languages
      t.text :other_comments

      t.timestamps
    end
  end
end
