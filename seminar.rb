#! /usr/bin/env ruby

require_relative './KOF/seminar'
require_relative './KOF/group'

Encoding.default_external = Encoding::UTF_8

include KOF

seminars = Seminar.open(ARGV[0])
groups = open(FILE_OF[:group]){|f| Group::read(f)}

seminars
  .sort_by{|s| s.date.nil? ? Time.local(2019, 11, 10, 0, 0, 0) : s.date}
  .each do |s|
    id = groups[[s.group, s.email]].id
    puts [id, s.date&.strftime("%Y-%m-%d %H:%M"), s.group, s.title, %Q|"#{s.abstract}"|].join("\t")
end
