# frozen_string_literal: true

class Pdf::FooterComponent < ViewComponent::Base
  def initialize(quotation:, custom_class: nil)
    @quotation = quotation
    @custom_class = custom_class
  end

  def glm_logo_url
    asset_url("pdf/logo-white.png")
  end

  def icons_data
    links = JSON.parse(@quotation.project.social_media_links || "{}")
    %w[icon1 icon2 icon3 icon4].each_with_object([]) do |icon, acc|
      image = @quotation.project.send(icon)
      next unless image.attached?

      acc << {
        image: image,
        link: links[icon]
      }
    end
  end
end
