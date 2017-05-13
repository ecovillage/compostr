require "compostr/version"

require 'ostruct'
require 'yaml'

require 'compostr/logging'

require 'compostr/custom_field_value'
require 'compostr/custom_post_type'

require 'compostr/entity_cache'

require 'compostr/syncer'

# Get the loggers, get the config, expose WP
module Compostr
  def self.load_conf
    @@config = OpenStruct.new YAML.load_file 'compostr.conf'
  end
  def self.config
    @@config ||= load_conf
  end

  def self.wp
    @wp ||= Rubypress::Client.new(host: config.host,
                                  username: config.username,
                                  password: config.password)
  end

  def self.logger
    @@logger ||= Logger.new(STDOUT)
  end
  def self.logger= logger
    @@logger = logger
  end
end
