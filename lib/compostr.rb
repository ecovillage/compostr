require "compostr/version"

require 'compostr/custom_field_value'
require 'compostr/custom_post_type'

require 'compostr/entity_cache'

module Compostr
  def self.logger
    @@logger || = Logger.new(STDOUT)
  end
  def self.logger= logger
    @@logger = logger
  end
end
