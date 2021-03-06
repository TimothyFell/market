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

  def total_inventory
    @vendors.reduce({}) do |inventory_total, vendor|
      if inventory_total == {}
        inventory_total = vendor.inventory
      else
        merge_inventories(inventory_total, vendor)
      end
    end
  end

  def merge_inventories(inventory_total, vendor)
    inventory_total.merge(vendor.inventory) do |key, oldval, newval|
      oldval + newval
    end
  end

  def sell(item, num)
    @vendors.reduce(num) do |number_sold, vendor|
      
      if total_inventory[item] == 0 || total_inventory[item] < number_sold

        return false

      elsif vendor.inventory[item] != 0 && vendor.inventory[item] <= number_sold

        sold_out_vendor = @vendors.find do |vendor|
          vendor.inventory.keys.include?(item)
        end

        number_sold -= sold_out_vendor.inventory[item]
        sold_out_vendor.inventory[item] = 0
        number_sold

      elsif vendor.inventory[item] != 0 && vendor.inventory[item] > number_sold

        vendor.inventory[item] -= number_sold
        return true

      else

        number_sold

      end
    end
  end

end
