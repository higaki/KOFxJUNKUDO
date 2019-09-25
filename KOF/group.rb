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

    def self.read(fn)
      open(fn, &:readlines)
        .map{|l| l.strip.split(/\t/)}
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
  end
end

# >> Loaded suite /home/higaki/kof/KOFxJUNKUDO/KOF/xmpfilter.tmpfile_7732-1
# >> Started
# >> ..
# >> Finished in 0.0009947 seconds.
# >> -------------------------------------------------------------------------------
# >> 2 tests, 15 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 2010.66 tests/s, 15079.92 assertions/s
