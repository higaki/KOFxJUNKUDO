#! /usr/bin/env ruby

require_relative './KOF/booth'
require_relative './KOF/seminar'
require_relative './KOF/group'

Encoding.default_external = Encoding::UTF_8

group_fn   = "groups.tsv"
booth_fn   = ARGV[0]
seminar_fn = ARGV[1]

include KOF

booths   = Booth  .open(booth_fn)
seminars = Seminar.open(seminar_fn)

groups = Group::read(group_fn)

(booths + seminars).each do |b|
  g = Group.new(b.group, b.email)
  key = g.key
  next if groups.include?(key)
  g.id = gen_id(groups, 1)
  groups[key] = g
end

open(group_fn, "w") do |f|
  f.puts groups.values.sort_by(&:id).map{|g|%i[id name email booth seminar junku].map{|i|g.__send__ i}.join("\t")}
end
