# frozen_string_literal: true

class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :source
      t.string :author
      t.string :title
      t.text :description
      t.text :content
      t.string :url
      t.string :url_to_image
      t.string :publish_at

      t.timestamps
    end
  end
end
