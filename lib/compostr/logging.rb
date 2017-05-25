require 'logger'

module Compostr
  # Module to extend to get easy access to standard log functions.
  # These are debug, info, warn, error and fatal.
  # All log functions use the Compostr.logger (which can be customized).
  # A typical client will just `extend Compostr::Logging` .
  module Logging
    def debug msg
      Compostr.logger.debug msg
    end
    def info msg
      Compostr.logger.info msg
    end
    def warn msg
      Compostr.logger.warn msg
    end
    def error msg
      Compostr.logger.error msg
    end
    def fatal msg
      Compostr.logger.fatal msg
    end
  end
end
