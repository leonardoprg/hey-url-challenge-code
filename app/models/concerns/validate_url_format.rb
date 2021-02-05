# frozen_string_literal: true

class ValidateUrlFormat
  def self.valid?(url:)
    uri = URI.parse(url)
    return true if uri.is_a?(URI::HTTP) && !uri.host.nil?

    false
  rescue StandardError
    false
  end
end
