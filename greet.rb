#! /usr/bin/env ruby

require_relative './KOF/kof'
require_relative './KOF/user'
require_relative './KOF/group'

Encoding.default_external = Encoding::UTF_8

groups = open(KOF::FILE_OF[:group]){|f| KOF::Group.read(f)} # rescue {}
users  = open(KOF::FILE_OF[:user ]){|f| KOF::User .read(f)} # rescue {}

def greet(group, entry, user)
  fn = "#{group.id}.txt"
  gname = group&.name&.strip || ""
  uname = user&.name&.sub(gname, "").strip || ""
  timelimit = "10月19日(土)"
  puts [fn, group.email, gname, user.name].join("\t")
  open(fn, "w") do |f|
    f.puts <<GREETING % [[gname, uname].reject(&:empty?).join(' '), entry.reject(&:nil?).join("および"), gname.empty? ? uname : gname, timelimit, timelimit]
%s様
関西オープンフォーラムの ひがき です。
%sにお申し込みいただき、ありがとうございます。

KOFでは、ジュンク堂書店KOF店と題して、KOF出展者の推薦書籍を会場で販売する企画を開催しています。
会場内のステージでは、推薦者ご自身に書籍を紹介していただく企画や、著者によるサイン会なども開催予定です。

そこで%s様にも書籍を推薦していただきたくご案内いたします。

書籍を推薦していただける場合は末尾の書籍推薦フォームの要領でご連絡ください。
%sまでに、ご回答いただけると助かります。

なお、書籍の推薦は必須ではありません。
推薦いただいているのは、例年KOF出展者全体の半数程度です。
ステージで紹介いただいているのは、更に半数程度。サイン会については会場に著者が来ていただいている場合に限り開催しています。

ステージでの書籍紹介の一例が <a href="https://k-of.jp/2015/session/790.html">こちら</a> でご覧いただけます。(司会付き 15分程度)

--------------------------------------------------------------------------------
書籍推薦フォーム
--------------------------------------------------------------------------------
1. 推薦書籍をご紹介ください。
# 例) プロを目指す人のためのRuby入門, 伊藤淳一, 技術評論社, ISBN978-4-7741-9397-7

2. ステージでの書籍紹介に
  参加する
  参加しない

3. サイン会を
  開催する (著者・翻訳者・イラスト:                                  )
  開催しない
--------------------------------------------------------------------------------

※ ご注意ください

洋書、希少本、雑誌バックナンバーなど、ご用意できない場合がございます。
あらかじめご了承ください。

書籍の発注に時間を要しますので、%sまでに、ご回答いただけると助かります。

よろしくお願いいたします。
GREETING
  end
end

categories = %w[ブース セミナー]

groups.values.each do |group|
  greet(group, [group.booth, group.seminar].zip(categories).map{|g, c| g && c}, users[group.email])
end
