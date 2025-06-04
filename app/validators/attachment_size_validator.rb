# app/validators/attachment_size_validator.rb
class AttachmentSizeValidator < ActiveModel::EachValidator
  DEFAULT_MAX = Rails.configuration.x.active_storage_max_upload_size

  def validate_each(record, attribute, _value)
    change = record.attachment_changes[attribute.to_s]
    return unless change

    upload = change.attachable

    size_in_bytes =
      if upload.respond_to?(:byte_size)
        upload.byte_size                      # for an ActiveStorage::Blob
      elsif upload.respond_to?(:size)
        upload.size                           # for an UploadedFile
      elsif upload.respond_to?(:tempfile)
        File.size(upload.tempfile.path)       # fallback
      else
        return                                # can't measure it
      end

    max_bytes = options[:less_than] || DEFAULT_MAX

    if size_in_bytes > max_bytes
      max_mb = (max_bytes.to_f / 1.megabyte).round(2)
      record.errors.add(
        attribute,
        options[:message] || "es demasiado grande. Tamaño máximo = #{max_mb} MB"
      )
    end
  end
end
