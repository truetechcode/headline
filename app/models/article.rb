# frozen_string_literal: true

# Represents an article in the application.
class Article < ApplicationRecord
  belongs_to :user
end
