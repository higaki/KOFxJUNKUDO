#! /usr/bin/env ruby

require_relative './KOF/kof'
require_relative './KOF/group'
require_relative './KOF/recommend'
require_relative './KOF/book'
require_relative './KOF/booth'
require_relative './KOF/seminar'
require_relative './KOF/stage'

Encoding.default_external = Encoding::UTF_8

using KOF

groups = open(KOF::FILE_OF[:group]){|f| KOF::Group.read(f)}
group_by = groups.values.inject({}){|gs, g| gs[g.id] = g; gs}
books = open(KOF::FILE_OF[:book]){|f| KOF::Book.read(f)}
recommendations = open(KOF::FILE_OF[:recommend]){|f| KOF::Recommendation.read(f)}

booth_by = KOF::Booth.open(ARGV[0])
  .inject({}){|bs, b| bs[[b.group, b.email]] = b; bs}
seminar_by = KOF::Seminar.open(ARGV[1])
  .inject({}){|ss, s| ss[[s.group, s.email]] = s; ss}
stage_by = KOF::Stage.open(ARGV[2])
  .inject({}){|ss, s| ss[[s.group, s.email]] = s; ss}

puts ["", "", "", "", "", "", "ブース", "", "セミナー", "", "書籍紹介"].join("\t")
puts %w[No. 出版社 ISBN/雑誌コード タイトル id コミュニティ 11/7 11/8 11/7 11/8 11/7 11/8 サイン会].join("\t")
recommendations.each_with_index do |rec, i|
  group   = group_by[rec.gid]
  book    = books[rec.isbn]
  booth   = booth_by[group.key]
  seminar = seminar_by[group.key]
  stage   = stage_by[group.key]
  columns = [
    i + 1,
    book.publisher,
    %Q|"#{rec.isbn.to_s.isbn}"|,
    book.to_hyperlink,
    rec.gid,
    group.name,
    booth ? booth.to_hyperlink(group.booth) : ["", ""],
    seminar ? seminar.to_hyperlink(group.seminar) : ["", ""],
    stage ? stage.to_hyperlink(group.junku) : ["", ""],
    rec.comment,
  ]
  puts columns.join("\t")
end
