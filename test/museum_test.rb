require_relative 'test_helper'

class MuseumTest < MiniTest::Test

  def setup
    @gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    @dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    @imax = Exhibit.new("IMAX", 15)
    @bob = Patron.new("Bob", 20)
    @sally = Patron.new("Sally", 20)
    @tj = Patron.new("TJ", 7)
    @morgan = Patron.new("Morgan", 15)
    @dmns = Museum.new("Denver Museum of Nature and Science")
  end

  def test_it_exists
    assert_instance_of Museum, @dmns
  end

  def test_it_initiates_with_properties
    assert_equal "Denver Museum of Nature and Science", @dmns.name
    assert_equal [], @dmns.exhibits
    assert_equal [], @dmns.patrons
  end

  def test_it_can_add_exhibits
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)

    expected = [@gems_and_minerals, @dead_sea_scrolls]

    assert_equal expected, @dmns.exhibits
  end

  def test_it_can_recommend_exhibits
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Gems and Minerals")
    @sally.add_interest("IMAX")

    bob_expected = [@gems_and_minerals, @dead_sea_scrolls]
    sally_expected = [@imax]

    assert_equal bob_expected, @dmns.recommend_exhibits(@bob)
    assert_equal sally_expected, @dmns.recommend_exhibits(@sally)
  end

  def test_it_can_admit_patrons
    @dmns.admit(@bob)
    @dmns.admit(@sally)

    expected = [@bob, @sally]

    assert_equal expected, @dmns.patrons
  end

  def test_it_can_show_patrons_by_exhibit_interest
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Gems and Minerals")
    @sally.add_interest("IMAX")
    @dmns.admit(@bob)
    @dmns.admit(@sally)

    expected = { @gems_and_minerals => [@bob],
                 @dead_sea_scrolls => [@bob],
                 @imax => [@sally] }

    assert_equal expected, @dmns.patrons_by_exhibit_interest
  end

  def test_it_charges_patrons_for_what_they_attended
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @tj.add_interest("IMAX")
    @tj.add_interest("Dead Sea Scrolls")
    @dmns.admit(@tj)
    assert_equal 7, @tj.spending_money

    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("IMAX")
    @dmns.admit(@bob)
    assert_equal 0, @bob.spending_money

    @sally.add_interest("Dead Sea Scrolls")
    @sally.add_interest("IMAX")
    @dmns.admit(@sally)
    assert_equal 5, @sally.spending_money

    @morgan.add_interest("Gems and Minerals")
    @morgan.add_interest("Dead Sea Scrolls")
    @dmns.admit(@morgan)
    assert_equal 5, @morgan.spending_money
  end

  def test_it_can_show_patrons_by_exhibit_attended
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @tj.add_interest("IMAX")
    @tj.add_interest("Dead Sea Scrolls")
    @dmns.admit(@tj)
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("IMAX")
    @dmns.admit(@bob)
    @sally.add_interest("Dead Sea Scrolls")
    @sally.add_interest("IMAX")
    @dmns.admit(@sally)
    @morgan.add_interest("Gems and Minerals")
    @morgan.add_interest("Dead Sea Scrolls")
    @dmns.admit(@morgan)

    expected = {@imax => [@sally],
                @dead_sea_scrolls => [@morgan, @bob],
                @gems_and_minerals => [@morgan]
              }

    assert_equal expected, @dmns.patrons_of_exhibits
  end

  def test_it_can_show_revenue
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    @tj.add_interest("IMAX")
    @tj.add_interest("Dead Sea Scrolls")
    @dmns.admit(@tj)
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("IMAX")
    @dmns.admit(@bob)
    @sally.add_interest("Dead Sea Scrolls")
    @sally.add_interest("IMAX")
    @dmns.admit(@sally)
    @morgan.add_interest("Gems and Minerals")
    @morgan.add_interest("Dead Sea Scrolls")
    @dmns.admit(@morgan)

    assert_equal 35, @dmns.revenue
  end

end
