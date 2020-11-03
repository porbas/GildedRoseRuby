class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      if sulfuras?(item)
      elsif generic?(item)
        if item.quality > 0
          item.quality -= 1
        end
        item.sell_in = item.sell_in - 1
        if item.sell_in < 0
          if item.quality > 0
            item.quality -= 1
          end
        end
      elsif aged_brie?(item)
        if item.quality < 50
          item.quality += 1
        end
        item.sell_in = item.sell_in - 1
        if item.sell_in < 0
          if item.quality < 50
            item.quality += 1
          end
        end
      elsif backstage_pass?(item)
        if item.quality < 50
          item.quality += 1
          if item.sell_in < 11
            if item.quality < 50
              item.quality += 1
            end
          end
          if item.sell_in < 6
            if item.quality < 50
              item.quality += 1
            end
          end
        end
        item.sell_in = item.sell_in - 1
        if item.sell_in < 0
          item.quality = item.quality - item.quality
        end
      end
    end
  end


  def aged_brie?(item)
    item.name == "Aged Brie"
  end

  def backstage_pass?(item)
    item.name == "Backstage passes to a TAFKAL80ETC concert"
  end

  def sulfuras?(item)
    item.name == "Sulfuras, Hand of Ragnaros"
  end

  def generic?(item)
    !(aged_brie?(item) || backstage_pass?(item) || sulfuras?(item))
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
