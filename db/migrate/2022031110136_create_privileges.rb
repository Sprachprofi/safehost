class CreatePrivileges < ActiveRecord::Migration[6.0]
  def change
    create_table :user_privileges do |t|
      t.string :privilege
      t.string :scope
      t.integer :user_id
      t.index ['user_id'], name: 'index_user_privileges_on_user_id', unique: false
    end
  end
end
