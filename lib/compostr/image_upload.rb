require 'mime-types'

module Compostr
  class ImageUpload
    attr_accessor :file_path, :post_id

    def initialize file_path, post_id=nil
      # TODO decide on getMediaLibrary to find an already uploaded image
      @file_path = file_path
      @post_id   = post_id
    end

    # Push data to Wordpress instance, return attachment_id
    def do_upload!
      data = create_data
      response = Compostr::wp.uploadFile(data: data)
      response["attachment_id"]
    end

    private

    def create_data
      {
        name: File.basename(@file_path),
        type: MIME::Types.type_for(file_path).first.to_s,
        post_id: @post_id || '',
        bits: XMLRPC::Base64.new(IO.read file_path)
      }
    end
  end
end
