#! /usr/bin/env ruby

require_relative './KOF/kof'
require_relative './KOF/group'

Encoding.default_external = Encoding::UTF_8

def to_tsv(g)
  base = "https://k-of.jp/backend/session"
  [
    g.id,
    g.name,
    g.booth.nil?   ? "" : [base, g.booth  ].join("/"),
    g.seminar.nil? ? "" : [base, g.seminar].join("/"),
    g.junku.nil?   ? "" : [base, g.junku  ].join("/"),
  ].join("\t")
end

def output_tsv(f, gs)
  f.puts %w[No. グループ ブース セミナー 書籍紹介].join("\t")
  f.puts gs.values.map{|g| to_tsv(g)}
end

output_tsv STDOUT, open(KOF::FILE_OF[:group]){|f| KOF::Group::read(f)}
