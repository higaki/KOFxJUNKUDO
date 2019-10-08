#! /usr/bin/env ruby

module KOF
  class Book
    def initialize(isbn, title, url, publisher)
      @isbn  = isbn.gsub('-', '').upcase
      @title = title || ''
      @url   = url || ''
      @publisher = publisher || ''
    end

    attr_accessor :isbn, :title, :url, :publisher

    def == o
      [isbn, title, url, publisher] == [o.isbn, o.title, o.url, o.publisher]
    rescue
      false
    end

    def self.read(io)
      io.map{|l| l.strip.split(/\t/)}
        .map{|isbn, title, url, pub| KOF::Book.new(isbn, title, url, pub)}
        .inject({}){|bs, b| bs[b.isbn] = b; bs}
    rescue SystemCallError
      {}
    end

    def self.add(isbn, books)
      isbn = isbn.gsub('-', '').upcase
      books[isbn] = Book.new(isbn, '', '', '') unless books.include? isbn
      books[isbn]
    end
  end
end


if $0 == __FILE__
  require 'test/unit'
  require 'stringio'

  class TestBook <Test::Unit::TestCase
    def test_new
      [ ["401X", "Alfa",  "alfa",  "ALFA",  KOF::Book.new("401X",   "Alfa",  "alfa",  "ALFA")],
        ["401X", "Alfa",  "alfa",  "ALFA",  KOF::Book.new("4-01-X", "Alfa",  "alfa",  "ALFA")],
        ["401X", "Alfa",  "alfa",  "ALFA",  KOF::Book.new("401x",   "Alfa",  "alfa",  "ALFA")],
        ["402X", "Bravo", "bravo", "BRAVO", KOF::Book.new("402X",   "Bravo", "bravo", "BRAVO")],
      ].each do |isbn, title, url, pub, actual|
        assert_equal isbn,  actual.isbn
        assert_equal title, actual.title
        assert_equal url,   actual.url
        assert_equal pub,   actual.publisher
      end
    end

    def test_equal
      [ ["401X", "Alfa",  "alfa", "ALFA",   "401X", "Alfa",  "alfa",  "ALFA",  true],
        ["401X", "Alfa",  "alfa", "ALFA",   "402X", "Alfa",  "alfa",  "ALFA",  false],
        ["401X", "Alfa",  "alfa", "ALFA",   "401X", "Bravo", "alfa",  "ALFA",  false],
        ["401X", "Alfa",  "alfa", "ALFA",   "401X", "Alfa",  "bravo", "ALFA",  false],
        ["401X", "Alfa",  "alfa", "ALFA",   "401X", "Alfa",  "alfa",  "BRAVO", false],
        ["401X", "Alfa",  "alfa", "ALFA", "4-01-X", "Alfa",  "alfa",  "ALFA",  true],
      ].each do |i|
        lhs = KOF::Book.new(*i[0..3])
        rhs = KOF::Book.new(*i[4..7])
        assert_equal i.last, lhs == rhs, i
      end
      assert_false KOF::Book.new("401X", "Alfa", "http://honto.jp/alfa", "ALFA") == %w[401X Alfa http://honto.jp/alfa]
    end

    def test_read_1book
      actual = KOF::Book.read(StringIO.new("401X\tAlfa\talfa\tALFA"))

      expectation = {"401X" => KOF::Book.new("401X", "Alfa", "alfa", "ALFA")}
      assert_equal expectation, actual
    end

    def test_read_2books
      actual = KOF::Book.read(StringIO.new("401X\tAlfa\talfa\tALFA\n402X\tBravo\tbravo\tBRAVO"))
      expectation = {
        "401X" => KOF::Book.new("401X", "Alfa",  "alfa",  "ALFA"),
        "402X" => KOF::Book.new("402X", "Bravo", "bravo", "BRAVO"),
      }
      assert_equal expectation, actual
    end

    def test_read_empty
      actual = KOF::Book.read(StringIO.new(""))
      expectation = {}
      assert_equal expectation, actual
    end

    def test_add
      books = {}
      KOF::Book.add("978-4-7741-9397-7", books);
      KOF::Book.add("978-4-86246-414-9", books);

      expectations = %w[9784774193977 9784862464149]

      assert_equal expectations, books.keys
      expectations.each do |isbn|
        book = books[isbn]
        assert_equal isbn, book.isbn
        assert_equal "",   book.title
        assert_equal "",   book.url
      end
    end

    def test_add_already_exists
      books = {
        "9784774193977" => KOF::Book.new("9784774193977", "プロを目指す人のための Ruby 入門", "https://honto.jp/netstore/pd-book_28745880.html", "技術評論社"),
        "9784862464149" => KOF::Book.new("9784862464149", "クリエイターのための権利の本",     "https://honto.jp/netstore/pd-book_29253824.html", " ボーンデジタル"),
      }

      assert_not_equal "", books["9784774193977"].title
      assert_not_equal "", books["9784862464149"].url

      KOF::Book.add("9784774193977",     books);
      KOF::Book.add("978-4-7741-9397-7", books);
      KOF::Book.add("9784862464149",     books);
      KOF::Book.add("978-4-86246-414-9", books);

      expectations = %w[9784774193977 9784862464149]

      assert_equal expectations, books.keys
      expectations.each do |isbn|
        book = books[isbn]
        assert_equal   isbn, book.isbn
        assert_not_equal "", book.title, "do NOT overwrite"
        assert_not_equal "", book.url,   "do NOT overwrite"
      end
    end
  end
end

# >> Loaded suite /home/higaki/kof/KOFxJUNKUDO/KOF/xmpfilter.tmpfile_12013-1
# >> Started
# >> .......
# >> Finished in 0.0017095 seconds.
# >> -------------------------------------------------------------------------------
# >> 7 tests, 42 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 4094.76 tests/s, 24568.59 assertions/s
