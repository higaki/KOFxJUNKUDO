#! /usr/bin/env ruby

require_relative './KOF/booth'
require_relative './KOF/group'

Encoding.default_external = Encoding::UTF_8

include KOF

booths = Booth.open(ARGV[0])
groups = open(FILE_OF[:group]){|f| Group::read(f)}

booths.each do |b|
  id = groups[[b.group, b.email]].id
  puts [id, b.dates.map{|d| d.nil? ? "x": "o"}, b.group, %Q|"#{b.abstract}"|].join("\t")
end
