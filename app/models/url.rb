# frozen_string_literal: true

class Url < ApplicationRecord
  scope :latest, -> { order(created_at: :desc).limit(10) }
  validates :original_url, :short_url, presence: true
  validates :short_url, length: { maximum: 5, minimum: 5 }
  validates :short_url, format: { with: /\A[A-Z]*\z/ }
  validates :short_url, uniqueness: true
  validate :original_url_format

  has_many :clicks, dependent: :destroy

  before_validation :generate_short_url, on: :create

  private

  def generate_short_url
    loop do
      self.short_url = GenerateShortUrl.generate
      break short_url unless Url.exists?(short_url: short_url)
    end
  end

  def original_url_format
    return if ValidateUrlFormat.valid?(url: original_url)

    errors.add(:original_url, :invalid)
  end
end
