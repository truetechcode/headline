# frozen_string_literal: true

# Migration to create the articles table
class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      add_user_reference(t)
      add_string_columns(t)
      add_text_columns(t)
      t.timestamps
    end
  end

  private

  def add_user_reference(table)
    table.references :user, null: false, foreign_key: true
  end

  def add_string_columns(table)
    table.string :source
    table.string :author
    table.string :title
    table.string :url
    table.string :url_to_image
    table.string :publish_at
  end

  def add_text_columns(table)
    table.text :description
    table.text :content
  end
end
