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

    def self.read(io)
      io.readlines
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
  require 'stringio'

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
        assert_equal i.last, lhs == rhs, i
      end

      assert_false KOF::User.new("a", "a@a") == ["a", "a@a"]
    end

    def test_read_1user
      actual = KOF::User.read(StringIO.new("1\tname\temail"))

      expectation = {"email" => KOF::User.new("name", "email", 1)}
      assert_equal expectation, actual
    end

    def test_read_2users
      actual = KOF::User.read(StringIO.new("2\tbravo\tbmail\n3\tcharlie\tcmail"))
      expectation = {
        "bmail" => KOF::User.new("bravo",   "bmail", 2),
        "cmail" => KOF::User.new("charlie", "cmail", 3),
      }
      assert_equal expectation, actual
    end

    def test_read_empty
      actual = KOF::User.read(StringIO.new(""))

      expectation = {}
      assert_equal expectation, actual
    end
  end
end

# >> Loaded suite /home/higaki/kof/KOFxJUNKUDO/KOF/xmpfilter.tmpfile_7400-1
# >> Started
# >> .....
# >> Finished in 0.0014061 seconds.
# >> -------------------------------------------------------------------------------
# >> 5 tests, 23 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 3555.93 tests/s, 16357.30 assertions/s
