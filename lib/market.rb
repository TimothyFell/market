# att: name, vendors
# meth: add_vendor, vendor_names, venders_that_sell()
class Market

  attr_reader :name,
              :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor_object)
    @vendors << vendor_object
  end

  def vendor_names
    @vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item)
    @vendors.find_all do |vendor|
      vendor.inventory.include?(item)
    end
  end

  def sorted_item_list
    @vendors.reduce([]) do |items, vendor|
      items << vendor.inventory.keys
    end.flatten.uniq.sort
  end

end
