# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      
      # Key data
      t.string :personal_name, limit: 100
      t.string :family_name, limit: 100
      t.string :mobile, limit: 50
      t.boolean :is_matcher
      t.boolean :is_host
      t.boolean :is_refugee
      t.string :languages
      t.text :social_links
      t.string :gender, limit: 1
      t.text :address
      t.string :postal_code, limit: 20
      t.string :city, limit: 100
      t.string :country, limit: 2
      
      # Verifications
      t.integer :verified_phone
      t.integer :verified_passport
      t.integer :verified_in_person
      t.integer :verified_address
      t.integer :trustworthiness # 0-10

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.inet     :current_sign_in_ip
      # t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
