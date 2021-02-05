# frozen_string_literal: true

class GenerateShortUrl
  def self.generate
    ('A'..'Z').to_a.sample(5).join
  end
end
