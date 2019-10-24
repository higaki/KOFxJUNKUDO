#! /usr/bin/env ruby

require 'csv'

module KOF
  IO_ENCODINGS = {
    external_encoding: Encoding::UTF_8,
    internal_encoding: __ENCODING__,
  }

  FILE_OF = {
    group: ",/groups.tsv",
    user:  ",/users.tsv",
    book:  "books.tsv",
    recommend: "recommendations.tsv",
  }

  URL_BASE = "https://k-of.jp/backend/session"

  def gen_id(gs, org)
    exists = gs.values.map(&:id)
    (org..).lazy.find{|i| !exists.include?(i)}
  end

  refine String do
    def to_narrow!
      wide2narrow = {
        "　" => " ", "０" => "0",
        "！" => "!", "１" => "1",
        "”" => '"', "２" => "2",
        "＃" => "#", "３" => "3",
        "＄" => "$", "４" => "4",
        "％" => "%", "５" => "5",
        "＆" => "&", "６" => "6",
        "’" => "'", "７" => "7",
        "（" => "(", "８" => "8",
        "）" => ")", "９" => "9",
        "＊" => "*", "：" => ":",
        "＋" => "+", "；" => ";",
        "，" => ",", "＜" => "<",
        "−" => "-", "＝" => "=",
        "．" => ".", "＞" => ">",
        "／" => "/", "？" => "?",

        "＠" => "@", "‘" => "`",
        "Ａ" => "A", "ａ" => "a",
        "Ｂ" => "B", "ｂ" => "b",
        "Ｃ" => "C", "ｃ" => "c",
        "Ｄ" => "D", "ｄ" => "d",
        "Ｅ" => "E", "ｅ" => "e",
        "Ｆ" => "F", "ｆ" => "f",
        "Ｇ" => "G", "ｇ" => "g",
        "Ｈ" => "H", "ｈ" => "h",
        "Ｉ" => "I", "ｉ" => "i",
        "Ｊ" => "J", "ｊ" => "j",
        "Ｋ" => "K", "ｋ" => "k",
        "Ｌ" => "L", "ｌ" => "l",
        "Ｍ" => "M", "ｍ" => "m",
        "Ｎ" => "N", "ｎ" => "n",
        "Ｏ" => "O", "ｏ" => "o",
        "Ｐ" => "P", "ｐ" => "p",
        "Ｑ" => "Q", "ｑ" => "q",
        "Ｒ" => "R", "ｒ" => "r",
        "Ｓ" => "S", "ｓ" => "s",
        "Ｔ" => "T", "ｔ" => "t",
        "Ｕ" => "U", "ｕ" => "u",
        "Ｖ" => "V", "ｖ" => "v",
        "Ｗ" => "W", "ｗ" => "w",
        "Ｘ" => "X", "ｘ" => "x",
        "Ｙ" => "Y", "ｙ" => "y",
        "Ｚ" => "Z", "ｚ" => "z",

        "［" => "[", "｛" => "{",
        "＼" => "\\","｜" => "|",
        "］" => "]", "｝" => "}",
        "＾" => "^",
        "＿" => "_",
      }
      wide   = wide2narrow.keys.join
      narrow = wide2narrow.values.join
      tr!(wide, narrow)
    end

    def regularize!
      res ||= to_narrow!
      res ||= strip!
      res ||= gsub!(/\s+/, ' ')
      ascii_only? ? res : gsub!(/\s/, '')
    end

    def regularize
      s = self.dup
      s.regularize!
      s
    end

    def to_times
      case self
      when %r|.*11/8|
        [Time.local(2019, 11, 8, 0, 0, 0), nil]
      when %r|.*11/9|
        [nil, Time.local(2019, 11, 9, 0, 0, 0)]
      when /.*11月(\d+)日\s+(\d+)時/
        t = Time.local(2019, 11, $1.to_i, $2.to_i, 0, 0)
        t.mday == 8 ? [t, nil] : [nil, t]
      when %r|11/0([89]) (\d+):(\d+)|
        t = Time.local(2019, 11, $1.to_i, $2.to_i, $3.to_i, 0)
        t.mday == 8 ? [t, nil] : [nil, t]
      when /両日|どちらの日でもよい/
        [8, 9].map{|i| Time.local(2019, 11, i, 0, 0, 0)}
      end
    end
  end
end

if $0 == __FILE__
  require 'test/unit'
  using KOF

  class TestKOF <Test::Unit::TestCase
    def test_to_times
      fri = Time.local(2019, 11, 8,  0, 0, 0)
      sat = Time.local(2019, 11, 9,  0, 0, 0)
      [ ["11月8日 16時",      [Time.local(2019, 11, 8, 16, 0, 0), nil]],
        ["11月9日 11時",      [nil, Time.local(2019, 11, 9, 11, 0, 0)]],
        ["2019/11/8(金曜日)", [fri, nil]],
        ["2019/11/9(土曜日)", [nil, sat]],
        ["どちらの日でもよい",  [fri, sat]],
        ["11/8 (金曜日) のみ", [fri, nil]],
        ["11/9 (土曜日) のみ", [nil, sat]],
        ["両日",              [fri, sat]],
      ].each do |src, exp|
        assert_equal exp, src.to_times
      end
    end
  end
end
# >> Loaded suite -
# >> Started
# >> .
# >> Finished in 0.000443 seconds.
# >> -------------------------------------------------------------------------------
# >> 1 tests, 8 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 2257.34 tests/s, 18058.69 assertions/s
