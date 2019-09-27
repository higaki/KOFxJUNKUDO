#! /usr/bin/env ruby

module KOF
  class Book
    def initialize(isbn, title, url)
      @isbn, @title, @url = isbn.gsub('-', '').upcase, title || '', url || ''
    end

    attr_accessor :isbn, :title, :url

    def == o
      [isbn, title, url] == [o.isbn, o.title, o.url]
    rescue
      false
    end

    def self.read(io)
      io.map{|l| l.strip.split(/\t/)}
        .map{|isbn, title, url| KOF::Book.new(isbn, title, url)}
        .inject({}){|bs, b| bs[b.isbn] = b; bs}
    rescue SystemCallError
      {}
    end

    def self.add(isbn, books)
      isbn = isbn.gsub('-', '').upcase
      books[isbn] = Book.new(isbn, '', '') unless books.include? isbn
      books[isbn]
    end
  end
end


if $0 == __FILE__
  require 'test/unit'
  require 'stringio'

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

    def test_read_1book
      actual = KOF::Book.read(StringIO.new("401X\tAlfa\talfa"))

      expectation = {"401X" => KOF::Book.new("401X", "Alfa", "alfa")}
      assert_equal expectation, actual
    end

    def test_read_2books
      actual = KOF::Book.read(StringIO.new("401X\tAlfa\talfa\n402X\tBravo\tbravo"))
      expectation = {
        "401X" => KOF::Book.new("401X", "Alfa",  "alfa"),
        "402X" => KOF::Book.new("402X", "Bravo", "bravo"),
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
        "9784774193977" => KOF::Book.new("9784774193977", "プロを目指す人のための Ruby 入門", "https://honto.jp/netstore/pd-book_28745880.html"),
        "9784862464149" => KOF::Book.new("9784862464149", "クリエイターのための権利の本", "https://honto.jp/netstore/pd-book_29253824.html"),
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

# >> Loaded suite /home/higaki/kof/KOFxJUNKUDO/KOF/xmpfilter.tmpfile_2403-1
# >> Started
# >> .......
# >> Finished in 0.0017355 seconds.
# >> -------------------------------------------------------------------------------
# >> 7 tests, 37 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 4033.42 tests/s, 21319.50 assertions/s
