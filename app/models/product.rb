# frozen_string_literal: true

class Product < ApplicationRecord
  SHARE_IMAGE_SIZE = [1200, 630].freeze
  SHARE_IMAGE_QUALITY = 78

  belongs_to :category
  has_many_attached :images
  has_many :bids, dependent: :destroy
  validates :lot_number, :description, presence: true

  def share_image
    images.first if images.attached?
  end

  def share_image_variant
    return unless share_image&.variable?

    share_image.variant(
      resize_to_limit: SHARE_IMAGE_SIZE,
      format: :jpg,
      saver: { quality: SHARE_IMAGE_QUALITY, strip: true }
    )
  end

  def youtube_id
    return nil if link_video.blank?

    uri = URI.parse(link_video)
    host = uri.host.to_s

    if host.include?('youtu.be')
      uri.path.delete_prefix('/')
    elsif host.include?('youtube.com')
      Rack::Utils.parse_query(uri.query)['v']
    end
  rescue URI::InvalidURIError
    nil
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
