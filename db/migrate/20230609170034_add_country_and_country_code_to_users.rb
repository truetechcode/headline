# frozen_string_literal: true

# This migration adds the `country` and `country_code` columns to the `users` table.
# It also creates indexes on the `country` and `country_code` columns for faster queries.
class AddCountryAndCountryCodeToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :country
      t.string :country_code
      t.index :country
      t.index :country_code
    end
  end
end
