module Assertions
  def assert_backstage_pass_quality(expected, sell_in, quality)
    items = [Item.new("Backstage passes to a TAFKAL80ETC concert", sell_in, quality)]
    GildedRose.new(items).update_quality
    assert_equal(expected, items[0].quality)
  end

  def assert_aged_brie_quality(expected, sell_in, quality)
    items = [Item.new("Aged Brie", sell_in, quality)]
    GildedRose.new(items).update_quality
    assert_equal(expected, items[0].quality)
  end

  def assert_generic_quality(expected, sell_in, quality)
    items = [Item.new("foo", sell_in, quality)]
    GildedRose.new(items).update_quality
    assert_equal(expected, items[0].quality)
  end
end
