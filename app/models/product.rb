# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category
  has_many_attached :images
  has_many :bids, dependent: :destroy
  validates :lot_number, :description, presence: true

  def youtube_id
    return nil if link_video.blank?

    uri = URI.parse(link_video)

    if uri.host.include?('youtu.be')
      uri.path.delete_prefix('/')
    elsif uri.host.include?('youtube.com')
      Rack::Utils.parse_query(uri.query)['v']
    end
  end

  def video_embed_url
    return nil unless youtube_id

    "https://www.youtube.com/embed/#{youtube_id}"
  end

  def video_thumbnail_url
    return nil unless youtube_id

    "https://img.youtube.com/vi/#{youtube_id}/maxresdefault.jpg"
  end
end
