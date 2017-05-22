require 'test_helper'

class CompostrTest < Minitest::Test
  @@conf = {
    host:     "wordpress.mydomain",
    username: "admin",
    password: "buzzword"
  }

  def setup
    WebMock.disable_net_connect!
  end

  def test_that_it_has_a_version_number
    refute_nil ::Compostr::VERSION
  end

  def test_failing_post_deletion
    YAML.stub(:load_file, @@conf, Minitest::Mock.new) do
      VCR.use_cassette('wp_failing_post_deletion') do
        assert_equal(false, Compostr.delete_post("100000"))
      end
      VCR.use_cassette('wp_successful_post_deletion') do
        #assert_equals(false, Compostr.delete_post("1"))
      end
    end
  end
end
