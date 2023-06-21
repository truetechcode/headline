# frozen_string_literal: true

# AddEmailIndexToUsers migration is responsible for adding an index
# on the email column of the users table to enforce uniqueness.
class AddEmailIndexToUsers < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :email, unique: true
  end
end
