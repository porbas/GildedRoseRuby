require 'test_helper'
require 'gilded_rose'

class TestUntitled < Minitest::Test
  cover "Inventory"
  include Assertions

  def test_report
    report_lines = []
    items = [
      Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20),
      Item.new(name="Aged Brie", sell_in=2, quality=0),
      Item.new(name="Elixir of the Mongoose", sell_in=5, quality=7),
      Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=0, quality=80),
      Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=-1, quality=80),
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=15, quality=20),
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=49),
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=49),
      # This Conjured item does not work properly yet
      Item.new(name="Conjured Mana Cake", sell_in=3, quality=6), # <-- :O
    ]

    days = 2

    gilded_rose = GildedRose.new items
    (0...days).each do |day|
      report_lines << "-------- day #{day} --------"
      report_lines << "name, sellIn, quality"
      items.each do |item|
        report_lines << item.to_s
      end
      report_lines << ""
      gilded_rose.update_quality
    end


    expected = <<~EOT.split("\n") + [""]
      -------- day 0 --------
      name, sellIn, quality
      +5 Dexterity Vest, 10, 20
      Aged Brie, 2, 0
      Elixir of the Mongoose, 5, 7
      Sulfuras, Hand of Ragnaros, 0, 80
      Sulfuras, Hand of Ragnaros, -1, 80
      Backstage passes to a TAFKAL80ETC concert, 15, 20
      Backstage passes to a TAFKAL80ETC concert, 10, 49
      Backstage passes to a TAFKAL80ETC concert, 5, 49
      Conjured Mana Cake, 3, 6

      -------- day 1 --------
      name, sellIn, quality
      +5 Dexterity Vest, 9, 19
      Aged Brie, 1, 1
      Elixir of the Mongoose, 4, 6
      Sulfuras, Hand of Ragnaros, 0, 80
      Sulfuras, Hand of Ragnaros, -1, 80
      Backstage passes to a TAFKAL80ETC concert, 14, 21
      Backstage passes to a TAFKAL80ETC concert, 9, 50
      Backstage passes to a TAFKAL80ETC concert, 4, 50
      Conjured Mana Cake, 2, 5
      EOT

    assert_equal expected, report_lines
  end

  def test_backstage_pass
    assert_backstage_pass_quality 22, 8, 20
    assert_backstage_pass_quality 23, 5, 20
    assert_backstage_pass_quality 0, 0, 20
    assert_backstage_pass_quality 50, 100, 50
    assert_backstage_pass_quality 50, 100, 49
    assert_backstage_pass_quality 49, 11, 48
    assert_backstage_pass_quality 23, 2, 20
    assert_backstage_pass_quality 23, 1, 20
    assert_backstage_pass_quality 22, 6, 20
    assert_backstage_pass_quality 22, 10, 20
    assert_backstage_pass_quality 49, 1, 46
    assert_backstage_pass_quality 50, 1, 47
    assert_backstage_pass_quality 50, 1, 48
    assert_backstage_pass_quality 50, 1, 49

  end

  def test_aged_brie
    assert_aged_brie_quality(22, 0, 20)
  end

  def test_generic
    items = [Item.new("foo", -1, 3)]
    GildedRose.new(items).update_quality
    assert_equal(1, items[0].quality)
  end
end
