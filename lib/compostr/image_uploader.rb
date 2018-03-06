require 'mime-types'

module Compostr
  class ImageUploader
    attr_accessor :image_store
    attr_accessor :media_cache

    def initialize image_store, media_cache
      if !image_store
        Compostr.logger.warn "ImageUploader will not upload anything (no image store specified)."
      end
      @image_store = image_store
      @media_cache = media_cache
    end

    # Returns attachment id of an image already uploaded
    # or attachment_id of image after fresh upload
    # (or nil if path empty)
    # path is relative path to file to upload.
    def process rel_path, wp_event=nil
      return nil if rel_path.to_s.strip.empty?

      # Do we need URI encoding here?
      if attachment_id = @media_cache.id_of_name(rel_path)
        Compostr.logger.debug "Image already uploaded."
      else
        return nil if @image_store.nil?
        path = File.join(@image_store, rel_path)
        Compostr.logger.info "Uploading file #{path}"
        upload = Compostr::ImageUpload.new(path)
        attachment_id = upload.do_upload!
        Compostr.logger.debug "Uploaded image id: #{attachment_id}"
      end

      return attachment_id
    end
  end
end
