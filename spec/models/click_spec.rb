# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Click, type: :model do
  describe 'validations' do
    it 'validates url_id is valid' do
      click = Click.new
      click.valid?
      expect(click.errors[:url]).to eql(['must exist'])
    end

    it 'validates browser is not null' do
      click = Click.new
      click.valid?
      expect(click.errors[:browser]).to eql(["can't be blank"])
    end

    it 'validates platform is not null' do
      click = Click.new
      click.valid?
      expect(click.errors[:platform]).to eql(["can't be blank"])
    end
  end
end
