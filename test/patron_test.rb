require_relative 'test_helper'

class PatronTest < MiniTest::Test
  
  def setup
    @bob = Patron.new("Bob", 20)
  end

  def test_it_exists
    assert_instance_of Patron, @bob
  end

  def test_it_initiates_with_properties
    assert_equal "Bob", @bob.name
    assert_equal 20, @bob.spending_money
    assert_equal [], @bob.interests
  end

  def test_it_can_add_interests
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Gems and Minerals")

    expected = ["Dead Sea Scrolls", "Gems and Minerals"]

    assert_equal expected, @bob.interests
  end

end
