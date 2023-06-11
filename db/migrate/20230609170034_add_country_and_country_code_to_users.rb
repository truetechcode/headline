class AddCountryAndCountryCodeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :country, :string
    add_column :users, :country_code, :string
    add_index  :users, :country
    add_index  :users, :country_code
  end
end
