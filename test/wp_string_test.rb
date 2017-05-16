require 'test_helper'

class WPStringTest < Minitest::Test
  def test_accepts_all
    assert_equal('', Compostr::WPString.wp_string(nil))
    assert_equal('1.7', Compostr::WPString.wp_string(1.7))
    assert_equal('Class', Compostr::WPString.wp_string(Class))
  end

  def test_strip
    assert_equal('both',  Compostr::WPString.wp_string(' both '))
    assert_equal('left',  Compostr::WPString.wp_string('  left'))
    assert_equal('right', Compostr::WPString.wp_string('right '))
    assert_equal('no ne', Compostr::WPString.wp_string('no ne '))
  end

  def test_whitemarkup
    assert_equal('<h1>head</h1>', Compostr::WPString.wp_string('<h1>head</h1>'))
    assert_equal('', Compostr::WPString.wp_string('<h1></h1>'))
    assert_equal('', Compostr::WPString.wp_string(' <strong><h1></h1></strong> '))
    assert_equal('<strong><h1>head</h1></strong>', Compostr::WPString.wp_string(' <strong><h1>head</h1></strong> '))
    assert_equal('<img href=""/>', Compostr::WPString.wp_string(' <img href=""/> '))
  end
end
