require 'test_helper'

class BoardgameCPT < Compostr::CustomPostType
  wp_post_type "boardgames"
  wp_post_title_alias    "name"
  wp_custom_field_single "year"
  wp_custom_field_single "uuid"

  additional_field_action :add
end

class CPTTest < Minitest::Test
  def setup
    WebMock.disable_net_connect!
    ##stub_request(:post, "http://wordpress.mydomain/xmlrpc.php").
    ##  with(body: /.*wp.newPost.*/).
    ##  to_return(status: 200, body: "", headers: {})
  end

  def test_new_entity
    conf = {
      host:     "wordpress.mydomain",
      username: "admin",
      password: "buzzword"
    }
    YAML.stub(:load_file, conf, Minitest::Mock.new) do
      dungeonlord = BoardgameCPT.new name: 'Dungeonlord'
      syncer = Compostr::Syncer.new nil
      VCR.use_cassette('syncer_push_dungeonlord') do
        syncer.merge_push dungeonlord, nil
        assert_equal dungeonlord.post_id, "2766"
      end
    end
  end
end

