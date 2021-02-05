# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do
    context 'original_url is not present' do
      it 'adds an error to original url' do
        url = Url.new(original_url: nil)
        url.valid?
        expect(url.errors[:original_url]).to include(
          "can't be blank"
        )
      end
    end

    context 'original_url is invalid url' do
      it 'adds an error to original url' do
        url = Url.new(original_url: 'idsaldjsa')
        url.valid?
        expect(url.errors[:original_url]).to eql(
          ['is invalid']
        )
      end
    end

    context 'short_url is not present' do
      it 'adds an error to short url' do
        allow(GenerateShortUrl).to receive(:generate).and_return(nil)
        url = Url.new
        url.valid?
        expect(url.errors[:short_url]).to include(
          "can't be blank"
        )
      end
    end

    context 'short_url has more than 5 chars' do
      it 'adds an error to short url' do
        allow(GenerateShortUrl).to receive(:generate).and_return('AEVCHDYH')
        url = Url.new
        url.valid?
        expect(url.errors[:short_url]).to eql(
          ['is too long (maximum is 5 characters)']
        )
      end
    end

    context 'short_url has less than 5 chars' do
      it 'adds an error to short url' do
        allow(GenerateShortUrl).to receive(:generate).and_return('AEB')
        url = Url.new
        url.valid?
        expect(url.errors[:short_url]).to eql(
          ['is too short (minimum is 5 characters)']
        )
      end
    end

    context 'short_url has an invalid format' do
      let(:short_url) { ['AE BC', 'AEdBC', 'AD$CV'].sample }

      it 'adds an error to short url' do
        allow(GenerateShortUrl).to receive(:generate).and_return(short_url)
        url = Url.new
        url.valid?
        expect(url.errors[:short_url]).to eql(
          ['is invalid']
        )
      end
    end
  end

  describe '#generate_short_url' do
    it 'generates a new valid short url' do
      url = Url.create(original_url: 'http://www.google.com')
      expect(url.short_url.length).to be(5)
    end
  end
end
