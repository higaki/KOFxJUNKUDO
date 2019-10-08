#! /usr/bin/env ruby

require_relative './KOF/kof'
require_relative './KOF/book'
require_relative './KOF/group'
require_relative './KOF/user'
require_relative './KOF/recommend'

Encoding.default_external = Encoding::UTF_8

groups = open(KOF::FILE_OF[:group]){|f| KOF::Group.read(f)}
  .values.inject({}){|gs, g| gs[g.id] = g; gs}
users  = open(KOF::FILE_OF[:user ]){|f| KOF::User .read(f)} # rescue {}
books = open(KOF::FILE_OF[:book]){|f| KOF::Book.read(f)}

fmt = <<CONFIRM
%s様
関西オープンフォーラムの ひがき です。

書籍の推薦ありがとうございます。

以下の通り承りました。

%s

ステージでの書籍紹介に「参加%s」
サイン会を「開催%s」

よろしくお願いいたします。
CONFIRM

def booklist recommends, books
  recommends.map do |r|
    book = books[r.isbn]
    %|<a href="#{book&.url}">#{book&.title}</a>|
  end.join("\n")
end

open(KOF::FILE_OF[:recommend]){|f| KOF::Recommendation.read(f)}
  .group_by{|r| r.gid}
  .each do |gid, rs|
    group = groups[gid]
    fn = "#{group&.id}.txt"
    gname = group&.name&.strip || ""
    uname = users[group&.email]&.name&.sub(gname, "").strip || ""
    talk = rs.map(&:talker).reject(&:nil?).reject(&:empty?).empty? ? "しない" : "する"
    sign = rs.map(&:author).reject(&:nil?).reject(&:empty?).empty? ? "しない" : "する"
    open(fn, "w") do |f|
      f.puts fmt % [[gname, uname].reject(&:empty?).join(' '), booklist(rs, books), talk, sign]
    end
end
