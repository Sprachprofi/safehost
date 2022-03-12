class AddIdentityToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :id_or_passport_no, :string, limit: 20
  end
end
