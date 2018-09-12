require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/vendor'
require './lib/market'

class MarketTest < Minitest::Test

  def test_it_exits
    market = Market.new("South Pearl Market")

    assert_instance_of Market, market
  end

  def test_it_has_name
    market = Market.new("South Pearl Market")

    assert_equal "South Pearl Market", market.name
  end

  def test_starts_with_no_vendors
    market = Market.new("South Pearl Market")

    assert_equal [], market.vendors
  end

  def test_it_can_add_vendors
    market = Market.new("South Pearl Market")

    vendor_1 = Vendor.new("Rocky Mountain Fresh")
    market.add_vendor(vendor_1)
    assert_equal [vendor_1], market.vendors

    vendor_2 = Vendor.new("Ba-Nom-a-Nom")
    market.add_vendor(vendor_2)
    assert_equal [vendor_1,vendor_2], market.vendors

    vendor_3 = Vendor.new("Palisade Peach Shack")
    market.add_vendor(vendor_3)
    assert_equal [vendor_1,vendor_2,vendor_3], market.vendors
  end

  def test_it_can_recall_vendor_names
    market = Market.new("South Pearl Market")

    vendor_1 = Vendor.new("Rocky Mountain Fresh")
    market.add_vendor(vendor_1)

    vendor_2 = Vendor.new("Ba-Nom-a-Nom")
    market.add_vendor(vendor_2)

    vendor_3 = Vendor.new("Palisade Peach Shack")
    market.add_vendor(vendor_3)

    expected = [vendor_1.name, vendor_2.name, vendor_3.name]
    assert_equal expected, market.vendor_names
  end

  def test_it_can_find_vendors_who_sell_something
    market = Market.new("South Pearl Market")

    vendor_1 = Vendor.new("Rocky Mountain Fresh")
    vendor_1.stock("Peaches", 35)
    vendor_1.stock("Tomatoes", 7)
    market.add_vendor(vendor_1)

    vendor_2 = Vendor.new("Ba-Nom-a-Nom")
    vendor_2.stock("Banana Nice Cream", 50)
    vendor_2.stock("Peach-Raspberry Nice Cream", 25)
    market.add_vendor(vendor_2)

    vendor_3 = Vendor.new("Palisade Peach Shack")
    vendor_3.stock("Peaches", 65)
    market.add_vendor(vendor_3)

    expected_1 = [vendor_1, vendor_3]
    assert_equal expected_1, market.vendors_that_sell("Peaches")

    expected_2 = [vendor_2]
    assert_equal expected_2, market.vendors_that_sell("Banana Nice Cream")
  end

end