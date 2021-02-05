# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  describe 'GET #index' do
    it 'shows the latest 10 URLs' do
      15.times { Url.create!(original_url: 'http://www.google.com') }
      get :index
      expect(assigns(:urls).size).to eql(10)
    end
  end

  describe 'POST #create' do
    context 'when param is valid' do
      it 'creates a new url' do
        expect do
          post :create, params: { url: { original_url: 'http://www.google.com' } }
        end.to change { Url.count }.by(1)
      end

      it 'redirects to urls path' do
        subject = post :create, params: { url: { original_url: 'http://www.google.com' } }
        expect(subject).to redirect_to(urls_path)
      end
    end

    context 'when param is invalid' do
      it 'does not creates new url' do
        expect do
          post :create, params: { url: { original_url: '' } }
        end.to change { Url.count }.by(0)
      end

      it 'redirects to urls path' do
        subject = post :create, params: { url: { original_url: '' } }
        expect(subject).to redirect_to(urls_path)
      end

      it 'sets flash message with url error' do
        post :create, params: { url: { original_url: '' } }
        expect(flash[:notice]).to eql(
          "Original url can't be blank, Original url is invalid"
        )
      end
    end
  end

  describe 'GET #show' do
    let(:url) { Url.create(original_url: 'http://www.google.com') }

    before do
      url.clicks.create(platform: 'OSX', browser: 'Firefox', created_at: 1.day.ago)
      url.clicks.create(platform: 'Window', browser: 'Firefox')
      url.clicks.create(platform: 'Window', browser: 'Chrome')
    end

    it 'shows daily clicks about the given URL' do
      get :show, params: { url: url.short_url }
      expect(assigns(:daily_clicks)).to eql([[1.day.ago.day, 1], [Time.zone.now.day, 2]])
    end

    it 'shows browser clicks about the given URL' do
      get :show, params: { url: url.short_url }
      expect(assigns(:browsers_clicks)).to eql([['Chrome', 1], ['Firefox', 2]])
    end

    it 'shows platform clicks about the given URL' do
      get :show, params: { url: url.short_url }
      expect(assigns(:platform_clicks)).to eql([['OSX', 1], ['Window', 2]])
    end

    it 'throws 404 when the URL is not found' do
      expect do
        get :show, params: { url: 'invalida url' }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #visit' do
    let(:url) { Url.create(original_url: 'http://www.google.com') }

    it 'tracks click event' do
      expect do
        get :visit, params: { url: url.short_url }
      end.to change { Click.count }.by(1)
    end

    it 'tracks platform user info' do
      get :visit, params: { url: url.short_url }
      expect(url.clicks.last.platform).to eql('Other')
    end

    it 'tracks browser user info' do
      get :visit, params: { url: url.short_url }
      expect(url.clicks.last.browser).to eql('Generic Browser')
    end

    it 'increments url click counts by 1' do
      get :visit, params: { url: url.short_url }
      expect(url.click_counts).to eql(1)
    end

    it 'redirects to the original url' do
      subject = get :visit, params: { url: url.short_url }
      expect(subject).to redirect_to('http://www.google.com')
    end

    it 'throws 404 when the URL is not found' do
      expect do
        get :visit, params: { url: 'invalid url' }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
