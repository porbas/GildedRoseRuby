class GildedRose; end
module GildedRose::Inventory

  class Quality
    attr_reader :amount

    def initialize(amount)
      @amount = amount
    end

    def degrade
      @amount -= 1 if amount > 0
    end

    def increase
      @amount +=1 if amount < 50
    end

    def reset
      @amount = 0
    end
  end

  class Generic
    def initialize(quality, sell_in)
      @quality, @sell_in = Quality.new(quality), sell_in
    end

    def quality
      @quality.amount
    end

    def update
      @quality.degrade
      @quality.degrade if @sell_in < 0
    end
  end

  class AgedBrie
    def initialize(quality, sell_in)
      @quality, @sell_in = Quality.new(quality), sell_in
    end

    def quality
      @quality.amount
    end

    def update
      @quality.increase
      @quality.increase if @sell_in < 0
    end
  end

  class BackstagePass
    def initialize(quality, sell_in)
      @quality, @sell_in = Quality.new(quality), sell_in
    end

    def quality
      @quality.amount
    end

    def update
      @quality.increase
      @quality.increase if @sell_in < 10
      @quality.increase if @sell_in < 5
      @quality.reset if @sell_in < 0
    end
  end

end


class GildedRose
  class GoodsCategory
    def build_for(item)
      case item.name
      when /Backstage passes/
        Inventory::BackstagePass.new(item.quality, item.sell_in)
      when /Aged Brie/
        Inventory::AgedBrie.new(item.quality, item.sell_in)
      else
        Inventory::Generic.new(item.quality, item.sell_in)
      end
    end
  end

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      next if sulfuras?(item)
      item.sell_in -=1
      obj = GoodsCategory.new.build_for(item)
      obj.update
      item.quality = obj.quality
    end
  end

  private

  def sulfuras?(item)
    item.name.eql? "Sulfuras, Hand of Ragnaros"
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
