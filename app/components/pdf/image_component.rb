# frozen_string_literal: true

class Pdf::ImageComponent < ViewComponent::Base
  def initialize(image: nil, width: nil, height: nil, custom_class: nil, path: nil, url: nil)
    @image = image
    @width = width
    @height = height
    @custom_class = custom_class
    @path = path
    @url = url
  end

  def image_url_path
    return @image.url if @image.present?
    return @url if @url.present?
    return @path if @path.present?

    asset_url("pdf/image-not-found.png")
  end
end
