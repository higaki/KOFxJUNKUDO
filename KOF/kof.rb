#! /usr/bin/env ruby

require 'csv'

module KOF
  class Kof
    @@io = {external_encoding: Encoding::UTF_8, internal_encoding: __ENCODING__}
  end

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

    def to_time
      case self
      when %r|.*11/([89])|
          [Time.local(2019, 11, $1.to_i, 0, 0, 0)]
      when /両日|どちらの日でもよい/
        [8, 9].map{|i| Time.local(2019, 11, i, 0, 0, 0)}
      end
    end
  end
end
