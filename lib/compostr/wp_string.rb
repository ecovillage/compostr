module Compostr
  module WPString
    def self.wp_string string
      content = string.strip
      if !string.to_s.match(/img/)
        re = /<("[^"]*"|'[^']*'|[^'">])*>/
        if content.gsub(re, '') == ''
          return ''
        end
      end
      content
    end
  end
end
