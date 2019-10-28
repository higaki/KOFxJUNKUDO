#! /usr/bin/env ruby

require_relative './KOF/group'
require_relative './KOF/book'
require_relative './KOF/recommend'
require_relative './KOF/booth'

Encoding.default_external = Encoding::UTF_8

include KOF
using KOF

group_by_key = open(FILE_OF[:group], **IO_ENCODINGS) {|f| Group.read(f)}
group_by_id  = group_by_key.values.inject({}){|gs, g| gs[g.id] = g; gs}

books = open(FILE_OF[:book], **IO_ENCODINGS) {|f| Book.read(f)}

recommends =
  open(FILE_OF[:recommend], **IO_ENCODINGS) {|f| Recommendation.read(f)}

booth_of = Booth.open(ARGV[0]).inject({}){|bs, b| bs[b.group] = b; bs}

def head
  puts "<"
end

def body group, isbn
  puts [group, isbn].join("\t")
end

def foot
  puts ">"
end

head

recommends.each do |r|
  g = group_by_id[r.gid]
  body(g.name, r.isbn.isbn) if g && booth_of[g.name]
end

foot
