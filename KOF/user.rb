#! /usr/bin/env ruby

module KOF
  class User
    def initialize(name, email, id = nil)
      @name, @email, @id = name, email, id&.to_i
    end

    attr_accessor :name, :email, :id

    def == o
      [id, name, email] == [o.id, o.name, o.email]
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
    end
  end
end

# >> Loaded suite /home/higaki/kof/KOFxJUNKUDO/KOF/xmpfilter.tmpfile_6598-1
# >> Started
# >> .
# >> Finished in 0.0003942 seconds.
# >> -------------------------------------------------------------------------------
# >> 1 tests, 7 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 2536.78 tests/s, 17757.48 assertions/s
