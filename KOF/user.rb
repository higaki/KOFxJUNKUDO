#! /usr/bin/env ruby

module KOF
  class User
    def initialize(name, email, id = nil)
      @name, @email, @id = name, email, id&.to_i
    end

    attr_accessor :name, :email, :id

    def == o
      [id, name, email] == [o.id, o.name, o.email]
    rescue
      false
    end

    def self.read(fn)
      open(fn, &:readlines)
        .map{|l| l.strip.split(/\t/)}
        .map{|id, name, email| KOF::User.new(name, email, id)}
        .inject({}){|us, u| us[u.email] = u; us}
    rescue SystemCallError
      {}
    end
  end
end


if $0 == __FILE__
  require 'test/unit'

  class TestUser <Test::Unit::TestCase
    def test_new
      [ ["a", "a@a", nil, KOF::User.new("a", "a@a")],
        ["b", "b@b", nil, KOF::User.new("b", "b@b", nil)],
        ["c", "c@c",   1, KOF::User.new("c", "c@c", 1)],
        ["d", "d@d",   2, KOF::User.new("d", "d@d", "2")],
      ].each do |name, email, id, actual|
        assert_equal(name,  actual.name)
        assert_equal(email, actual.email)
        assert_equal(id,    actual.id)
      end
    end

    def test_equal
      [ ["a", "a@a", nil,  "a", "a@a", nil,  true],
        ["a", "a@a", nil,  "a", "a@a", 1,    false],
        ["a", "a@a", 1,    "a", "a@a", 1,    true],
        ["a", "a@a", 1,    "b", "a@a", 1,    false],
        ["a", "a@a", 1,    "a", "a@b", 1,    false],
        ["a", "a@a", 1,    "a", "a@b", 2,    false],
        ["a", "a@a", 1,    "a", "a@a", "1",  true],
      ].each do |i|
        lhs = KOF::User.new(*[*0..2].map{|j|i[j]})
        rhs = KOF::User.new(*[*3..5].map{|j|i[j]})
        assert_equal lhs == rhs, i.last, i
      end

      assert_false KOF::User.new("a", "a@a") == ["a", "a@a"]
    end
  end
end

# >> Loaded suite /home/higaki/kof/KOFxJUNKUDO/KOF/xmpfilter.tmpfile_6836-1
# >> Started
# >> ..
# >> Finished in 0.0007981 seconds.
# >> -------------------------------------------------------------------------------
# >> 2 tests, 20 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 2505.95 tests/s, 25059.52 assertions/s
