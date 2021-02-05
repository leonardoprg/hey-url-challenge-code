# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenerateShortUrl do
  describe '.generate' do
    it 'returns 5 chars' do
      expect(GenerateShortUrl.generate.length).to eql(5)
    end

    it 'returns only alphabetic uppercase chars' do
      expect(GenerateShortUrl.generate).to match(/\A[A-Z]*\z/)
    end
  end
end
