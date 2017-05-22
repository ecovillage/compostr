require 'test_helper'

class CompostrTest < Minitest::Test
  @@conf = {
  }

  def setup
    WebMock.disable_net_connect!
  end

  def test_that_it_has_a_version_number
    refute_nil ::Compostr::VERSION
  end

  def test_post_deletion
    YAML.stub(:load_file, @@conf, Minitest::Mock.new) do
      VCR.use_cassette('wp_post_deletion') do
        assert_equals("fails", Compostr.delete_post("100000"))
      end
    end
  end
end
