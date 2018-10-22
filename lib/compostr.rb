require "compostr/version"

require 'ostruct'
require 'yaml'
require 'rubypress'

require 'compostr/logging'

require 'compostr/wp_string'

require 'compostr/custom_field_value'
require 'compostr/custom_post_type'

require 'compostr/entity_cache'
require 'compostr/media_library_cache'

require 'compostr/image_upload'
require 'compostr/image_uploader'

require 'compostr/syncer'

# Get the loggers, get the config, expose WP
module Compostr
  # Load and memoize 'compostr.conf'.
  def self.load_conf
    @@config = OpenStruct.new YAML.load_file 'compostr.conf'
  end

  # Access configuration hash.
  def self.config
    @@config ||= load_conf
  end

  # Access (and/or initialize) Rubypress client, settings initially pulled
  # from the configuration.
  def self.wp
    @wp ||= Rubypress::Client.new(host: config.host,
                                  username: config.username,
                                  password: config.password,
                                  use_ssl:  config.use_ssl)
  end

  # Access the logger, initialize and memoize it on demand.
  def self.logger
    @@logger ||= Logger.new(STDOUT)
  end

  # Set the logger.
  def self.logger= logger
    @@logger = logger
  end

  # Delete a post with given wordpress post_id
  def self.delete_post post_id
    begin
      Compostr::wp.deletePost(blog_id: 0, post_id: post_id)
    rescue XMLRPC::FaultException
      false
    end
  end
end
