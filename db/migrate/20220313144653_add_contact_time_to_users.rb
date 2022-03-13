class AddContactTimeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :contact_time, :string
  end
end
