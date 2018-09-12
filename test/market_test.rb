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

  def test_it_can_return_all_items_sorted_alphabetically
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

    expected = ["Banana Nice Cream", "Peach-Raspberry Nice Cream", "Peaches", "Tomatoes"]
    assert_equal expected, market.sorted_item_list
  end

  def test_it_can_merge_inventories
    market = Market.new("South Pearl Market")

    vendor_1 = Vendor.new("Rocky Mountain Fresh")
    vendor_1.stock("Peaches", 35)
    vendor_1.stock("Tomatoes", 7)
    market.add_vendor(vendor_1)

    vendor_3 = Vendor.new("Palisade Peach Shack")
    vendor_3.stock("Peaches", 65)
    market.add_vendor(vendor_3)

    expected = {"Peaches" => 100, "Tomatoes" => 7}
    actual = market.merge_inventories(vendor_1.inventory, vendor_3)
    assert_equal expected, actual
  end

  def test_it_can_return_a_complete_inventory
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

    expected = {"Peaches"=>100, "Tomatoes"=>7, "Banana Nice Cream"=>50, "Peach-Raspberry Nice Cream"=>25}
    assert_equal expected, market.total_inventory
  end

    def test_it_can_sell_items
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

      refute market.sell("Peaches", 200)
      refute market.sell("Onions", 1)

      assert market.sell("Banana Nice Cream", 5)
      assert_equal 45, vendor_2.check_stock("Banana Nice Cream")

      assert market.sell("Peaches", 40)
      assert_equal 0, vendor_1.check_stock("Peaches")
      assert_equal 60, vendor_3.check_stock("Peaches")
    end

end
