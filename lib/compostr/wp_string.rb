module Compostr
  module WPString
    def self.wp_string string
      content = string.to_s.strip
      if !content.match(/img/)
        re = /<("[^"]*"|'[^']*'|[^'">])*>/
        if content.gsub(re, '') == ''
          return ''
        end
      end
      content
    end
  end
end
