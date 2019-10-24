#! /usr/bin/env ruby

require_relative './KOF/kof'
require_relative './KOF/keynote'

Encoding.default_external = Encoding::UTF_8

KOF::Keynote.open(ARGV[0])
  .sort_by{|k| k.dates.reject(&:nil?)}
  .each_with_index do |k, i|
    puts [
      i + 1,
      k.title,
      k.group,
      k.talker,
      %Q|"#{k.abstract}"|,
      k.dates.map{|d| d.strftime("%H:%M") if d},
    ].join("\t")
end
