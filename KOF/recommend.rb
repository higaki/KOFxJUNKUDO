#! /usr/bin/env ruby

module KOF
  class Recommendation
    def initialize(gid, isbn, talker = nil, author = nil)
      @gid, @isbn, @talker, @author =
        gid.to_i, isbn.gsub('-', '').upcase, talker, author
    end

    attr_accessor :gid, :isbn, :talker, :author

    def == o
      [gid, isbn, talker, author] == [o.gid, o.isbn, o.talker, o.author]
    rescue
      false
    end
  end
end


if $0 == __FILE__
  require 'test/unit'

  class TestRecommendation <Test::Unit::TestCase
    def test_new
      [ [1, "401X", "alfa", "Alfa",  KOF::Recommendation.new(1, "401X", "alfa", "Alfa")],
        [2, "4020", "bravo",   nil,  KOF::Recommendation.new(2, "4020", "bravo")],
        [3, "4039",     nil,   nil,  KOF::Recommendation.new(3, "4039")],
        [4, "4044",     nil,   nil,  KOF::Recommendation.new("4", "4044")],
        [5, "405X",     nil,   nil,  KOF::Recommendation.new(5, "4-05-x")],
      ].each do |gid, isbn, talker, author, actual|
        assert_equal gid,    actual.gid
        assert_equal isbn,   actual.isbn
        assert_equal talker, actual.talker
        assert_equal author, actual.author
      end
    end

    def test_equal
      [ [1, "401X", "alfa", "Alfa",    1, "401X", "alfa",  "Alfa",   true],
        [1, "401X", "alfa", "Alfa",    1, "401X", "alfa",  nil,      false],
        [1, "401X", "alfa", "Alfa",    1, "401X", "bravo", "Alfa",   false],
        [1, "401X", "alfa", "Alfa",    1, "402X", "alfa",  "Alfa",   false],
        [1, "401X", "alfa", "Alfa",    2, "401X", "alfa",  "Alfa",   false],
      ].each do |i|
        lhs = KOF::Recommendation.new(*i[0..3])
        rhs = KOF::Recommendation.new(*i[4..7])
        assert_equal i.last, lhs == rhs, i
      end

      assert_false KOF::Recommendation.new(1, "401X", "alfa", nil) == [1, "401X", "alfa", nil]
    end
  end
end

# >> Loaded suite /home/higaki/kof/KOFxJUNKUDO/KOF/xmpfilter.tmpfile_3301-1
# >> Started
# >> ..
# >> Finished in 0.0004818 seconds.
# >> -------------------------------------------------------------------------------
# >> 2 tests, 26 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 4151.10 tests/s, 53964.30 assertions/s
