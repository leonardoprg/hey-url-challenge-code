# frozen_string_literal: true

class UrlsController < ApplicationController
  before_action :load_url, only: %i[show visit]
  def index
    @url = Url.new
    @urls = Url.latest
  end

  def create
    url = Url.new(url_params)
    flash[:notice] = url.errors.full_messages.join(', ') unless url.save
    redirect_to urls_path
  end

  def show
    @daily_clicks = @url.clicks.group_by_day_of_month(:created_at, series: false).count.to_a
    @browsers_clicks = @url.clicks.group(:browser).count.to_a
    @platform_clicks = @url.clicks.group(:platform).count.to_a
  end

  def visit
    @url.update!(clicks_count: @url.clicks_count + 1)
    @url.clicks.create!(platform: browser.platform.name, browser: browser.name)
    redirect_to @url.original_url
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end

  def load_url
    @url = Url.find_by(short_url: params[:url])
    raise ActiveRecord::RecordNotFound unless @url
  end
end
