#! /usr/bin/env ruby

module KOF
  class Group
    def initialize(name, email, id = nil, booth = nil, seminar = nil, junku = nil)
      @id, @name, @email, @booth, @seminar, @junku =
        id&.to_i, name, email, booth, seminar, junku
    end

    def key
      [name, email]
    end

    attr_accessor(*%i[id name email booth seminar junku])

    def == o
      factors = %i[id name email booth seminar junku]
      factors.map{|i|self.__send__(i)} == factors.map{|i|o.__send__(i)}
    rescue
      false
    end

    def self.read(io)
      io.map{|l| l.strip.split(/\t/)}
        .map{|id, name, email, booth, seminar, junku|
            booth   = nil  if booth&.empty?
            seminar = nil  if seminar&.empty?
            junku   = nil  if junku&.empty?
            KOF::Group.new(name, email, id, booth, seminar, junku)
        }
        .inject({}){|gs, g| gs[g.key] = g; gs}
    rescue SystemCallError
      {}
    end
  end
end


if $0 == __FILE__
  require 'test/unit'
  require 'stringio'

  class TestGroup <Test::Unit::TestCase
    def test_new
      [ ["a", "a@a", nil, nil, nil, nil, KOF::Group.new("a", "a@a")],
        ["a", "a@a", nil, nil, nil, nil, KOF::Group.new("a", "a@a", nil, nil, nil, nil)],
        ["a", "a@a",   1, nil, nil, nil, KOF::Group.new("a", "a@a", 1)],
        ["a", "a@a",   1, nil, nil, nil, KOF::Group.new("a", "a@a", "1")],
        ["a", "a@a", nil,   2, nil, nil, KOF::Group.new("a", "a@a", nil, 2)],
        ["a", "a@a", nil, nil,   3, nil, KOF::Group.new("a", "a@a", nil, nil, 3)],
        ["a", "a@a", nil, nil, nil,   4, KOF::Group.new("a", "a@a", nil, nil, nil, 4)],
      ].each do |i|
        actual = KOF::Group.new(*[*0..5].map{|j|i[j]})
        expectation = i.last
        assert_equal expectation, actual
      end
    end

    def test_equal
      [ ["a", "a@a", nil, nil, nil, nil,
         "a", "a@a", nil, nil, nil, nil,  true],
        ["a", "a@a", nil, nil, nil, nil,
         "b", "a@a", nil, nil, nil, nil,  false],
        ["a", "a@a", nil, nil, nil, nil,
         "a", "b@a", nil, nil, nil, nil,  false],
        ["a", "a@a", nil, nil, nil, nil,
         "a", "a@a",   1, nil, nil, nil,  false],
        ["a", "a@a", nil, nil, nil, nil,
         "a", "a@a", nil,   2, nil, nil,  false],
        ["a", "a@a", nil, nil, nil, nil,
         "a", "a@a", nil, nil,   3, nil,  false],
        ["a", "a@a", nil, nil, nil, nil,
         "a", "a@a", nil, nil, nil,   4,  false],
      ].each do |i|
        lhs = KOF::Group.new(*[*0.. 5].map{|j|i[j]})
        rhs = KOF::Group.new(*[*6..11].map{|j|i[j]})
        assert_equal i.last, lhs == rhs, i
      end

      assert_false KOF::Group.new("a", "a@a") == ["a", "a@a"]
    end

    def test_read_1group
      actual = KOF::Group.read(StringIO.new("1\talfa\tamail\t\t\t"))

      expectation = {%w[alfa amail] => KOF::Group.new("alfa", "amail", 1)}
      assert_equal expectation, actual
    end

    def test_read_2groups
      actual = KOF::Group
        .read(StringIO.new("2\tbravo\tbmail\t\t\tjunku\n3\tcharlie\tcmail\t\t\t"))
      expectation = {
        %w[bravo   bmail] => KOF::Group.new("bravo", "bmail", 2, nil, nil, "junku"),
        %w[charlie cmail] => KOF::Group.new("charlie", "cmail", 3),
      }
      assert_equal expectation, actual
    end

    def test_read_empty
      actual = KOF::Group.read(StringIO.new(""))

      expectation = {}
      assert_equal expectation, actual
    end
  end
end

# >> Loaded suite /home/higaki/kof/KOFxJUNKUDO/KOF/xmpfilter.tmpfile_8012-1
# >> Started
# >> .....
# >> Finished in 0.0009738 seconds.
# >> -------------------------------------------------------------------------------
# >> 5 tests, 18 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 5134.52 tests/s, 18484.29 assertions/s
