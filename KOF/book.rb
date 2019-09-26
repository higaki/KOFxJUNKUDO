#! /usr/bin/env ruby

module KOF
  class Book
    def initialize(isbn, title, url)
      @isbn, @title, @url = isbn.gsub('-', '').upcase, title, url
    end

    attr_accessor :isbn, :title, :url

    def == o
      [isbn, title, url] == [o.isbn, o.title, o.url]
    rescue
      false
    end
  end
end


if $0 == __FILE__
  require 'test/unit'

  class TestBook <Test::Unit::TestCase
    def test_new
      [ ["401X", "Alfa",  "alfa",  KOF::Book.new("401X",   "Alfa",  "alfa")],
        ["401X", "Alfa",  "alfa",  KOF::Book.new("4-01-X", "Alfa",  "alfa")],
        ["401X", "Alfa",  "alfa",  KOF::Book.new("401x",   "Alfa",  "alfa")],
        ["402X", "Bravo", "bravo", KOF::Book.new("402X",   "Bravo", "bravo")],
      ].each do |isbn, title, url, actual|
        assert_equal isbn,  actual.isbn
        assert_equal title, actual.title
        assert_equal url,   actual.url
      end
    end

    def test_equal
      [ ["401X", "Alfa",  "alfa",   "401X", "Alfa",  "alfa",  true],
        ["401X", "Alfa",  "alfa",   "402X", "Alfa",  "alfa",  false],
        ["401X", "Alfa",  "alfa",   "401X", "Bravo", "alfa",  false],
        ["401X", "Alfa",  "alfa",   "401X", "Alfa",  "bravo", false],
        ["401X", "Alfa",  "alfa", "4-01-X", "Alfa",  "alfa",  true],
      ].each do |i|
        lhs = KOF::Book.new(*i[0..2])
        rhs = KOF::Book.new(*i[3..5])
        assert_equal i.last, lhs == rhs, i
      end
      assert_false KOF::Book.new("401X", "Alfa", "http://honto.jp/alfa") == %w[401X Alfa http://honto.jp/alfa]
    end
  end
end

# >> Loaded suite /home/higaki/kof/KOFxJUNKUDO/KOF/xmpfilter.tmpfile_3023-1
# >> Started
# >> ..
# >> Finished in 0.000944 seconds.
# >> -------------------------------------------------------------------------------
# >> 2 tests, 18 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 2118.64 tests/s, 19067.80 assertions/s
