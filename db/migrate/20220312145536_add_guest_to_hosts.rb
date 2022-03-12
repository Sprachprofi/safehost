class AddGuestToHosts < ActiveRecord::Migration[6.0]
  def change
    add_column :hosts, :available, :boolean, default: true
    add_column :hosts, :guest_name, :string
    add_column :hosts, :guest_data, :string
    add_column :hosts, :pickup_data, :string
    add_column :hosts, :guest_end_date, :date
    add_index :hosts, :available
  end
end
