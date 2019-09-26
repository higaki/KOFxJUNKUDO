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

    def self.read(io)
      io.readlines.map{|l| Recommendation.new(*l.strip.split(/\t/))}
    end
  end
end


if $0 == __FILE__
  require 'test/unit'
  require 'stringio'

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

    def test_read_1recommendation
      actual = KOF::Recommendation.read(StringIO.new("1\t9784774193977\tひがき\t"))
      expectation = [KOF::Recommendation.new(1, "9784774193977", "ひがき", nil)]
      assert_equal expectation, actual
    end

    def test_read_3recommendations
      src = [
        [1, 9784774193977, "ひがき",   ""],
        [2, 9784862464149, "古賀海人", "古賀海人"],
        [3, 9784904807002, "",         ""],
      ].map{|r| r.join("\t")}.join("\n")
      actual = KOF::Recommendation.read(StringIO.new(src))
      expectation = [
        KOF::Recommendation.new(1, "9784774193977", "ひがき"),
        KOF::Recommendation.new(2, "9784862464149", "古賀海人", "古賀海人"),
        KOF::Recommendation.new(3, "9784904807002"),
      ]
      assert_equal expectation, actual
    end

    def test_read_empty
      actual = KOF::Recommendation.read(StringIO.new(""))
      expectation = []
      assert_equal expectation, actual
    end
  end
end

# >> Loaded suite /home/higaki/kof/KOFxJUNKUDO/KOF/xmpfilter.tmpfile_4258-1
# >> Started
# >> .....
# >> Finished in 0.0010908 seconds.
# >> -------------------------------------------------------------------------------
# >> 5 tests, 29 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 4583.79 tests/s, 26585.99 assertions/s
