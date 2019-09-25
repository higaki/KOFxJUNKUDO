#! /usr/bin/env ruby

require 'csv'

module KOF
  class Kof
    @@io = {external_encoding: Encoding::UTF_8, internal_encoding: __ENCODING__}

    def to_time(s)
      case s
      when %r|.*11/([89])|
          [Time.local(2019, 11, $1.to_i, 0, 0, 0)]
      when /両日|どちらの日でもよい/
        [8, 9].map{|i| Time.local(2019, 11, i, 0, 0, 0)}
      end
    end
  end

  def gen_id(gs, org)
    exists = gs.values.map(&:id)
    (org..).lazy.find{|i| !exists.include?(i)}
  end
end
