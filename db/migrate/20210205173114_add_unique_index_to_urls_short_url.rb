# frozen_string_literal: true

class AddUniqueIndexToUrlsShortUrl < ActiveRecord::Migration[5.2]
  def change
    add_index :urls, :short_url, unique: true
  end
end
