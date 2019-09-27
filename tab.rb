#! /usr/bin/env ruby

require_relative './KOF/kof'
require_relative './KOF/book'
require_relative './KOF/group'
require_relative './KOF/recommend'

Encoding.default_external = Encoding::UTF_8

groups = open(KOF::FILE_OF[:group]){|f| KOF::Group.read(f)}
  .values.inject({}){|gs, g| gs[g.id] = g; gs}
books = open(KOF::FILE_OF[:book]){|f| KOF::Book.read(f)}

open(KOF::FILE_OF[:recommend]){|f| KOF::Recommendation.read(f)}
  .group_by{|r| r.gid}
  .each do |gid, rs|
    rs.each do |r|
      p [groups[gid].name, books[r.isbn].title].join("\t")
    end
  end
