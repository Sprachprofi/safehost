class CreateConfirmedPhoneNumbers < ActiveRecord::Migration[6.0]
  def change
    create_table :confirmed_phone_numbers do |t|
      t.string :phone_no
      t.integer :user_id
      t.integer :pin_typing_attempts, :null => false, :default => 0
      t.integer :pin_sendings, :null => false, :default => 0

      t.timestamps
    end

    add_index :confirmed_phone_numbers, :phone_no, unique: true
  end
end
