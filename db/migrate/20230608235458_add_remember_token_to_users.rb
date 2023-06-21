# frozen_string_literal: true

# Migration to add remember_token column and index to users table
class AddRememberTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :remember_token, :string
    add_index  :users, :remember_token
  end
end
