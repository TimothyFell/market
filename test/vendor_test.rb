require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './lib/vendor'

class VendorTest < Minitest::Test

  def test_it_exists
    vendor = Vendor.new("Rocky Mountain Fresh")

    assert_instance_of Vendor, vendor
  end

  def test_it_has_name
    vendor = Vendor.new("Rocky Mountain Fresh")

    assert_equal "Rocky Mountain Fresh", vendor.name
  end

  def test_starts_with_no_inventory
    vendor = Vendor.new("Rocky Mountain Fresh")

    expected = {}
    assert_equal expected, vendor.inventory
  end

  def test_returns_0_for_missing_products
    vendor = Vendor.new("Rocky Mountain Fresh")

    assert_equal 0, vendor.check_stock("Peaches")
  end

  def test_can_stock_items
    vendor = Vendor.new("Rocky Mountain Fresh")

    assert_equal 0, vendor.check_stock("Peaches")
    vendor.stock("Peaches", 30)
    assert_equal 30, vendor.check_stock("Peaches")
    vendor.stock("Peaches", 25)
    assert_equal 55, vendor.check_stock("Peaches")
  end

  def test_can_stock_multiple_items
    vendor = Vendor.new("Rocky Mountain Fresh")

    vendor.stock("Peaches", 30)
    vendor.stock("Peaches", 25)
    assert_equal 55, vendor.check_stock("Peaches")
    vendor.stock("Tomatoes", 12)
    assert_equal 12, vendor.check_stock("Tomatoes")
    expected = {"Peaches" => 55, "Tomatoes" => 12}
    assert_equal expected, vendor.inventory
  end

end
