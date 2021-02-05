# frozen_string_literal: true

url = Url.create!(original_url: 'http://www.google.com')
url.clicks.create!(browser: 'Firefox', platform: 'OSX', created_at: 1.day.ago)
url.clicks.create!(browser: 'Firefox', platform: 'OSX')
url.clicks.create!(browser: 'Chrome', platform: 'Linux')
