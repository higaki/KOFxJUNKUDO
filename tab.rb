#! /usr/bin/env ruby

require_relative './KOF/kof'
require_relative './KOF/book'
require_relative './KOF/group'
require_relative './KOF/recommend'

Encoding.default_external = Encoding::UTF_8

groups = open(KOF::FILE_OF[:group]){|f| KOF::Group.read(f)}
  .values.inject({}){|gs, g| gs[g.id] = g; gs}
books = open(KOF::FILE_OF[:book]){|f| KOF::Book.read(f)}

def li book
  case
  when book.url.nil? then book.title
  else %|<a href="#{book.url}">#{book.title}</a>|
  end
end

def ul books
  books.map{|b| li b}
end

def tr gname, books, even
  puts <<TR
    <tr#{even ? '' : ' style="background:#fffee0;"'}>
      <td>#{gname}</td>
      <td>#{ul(books).join("<br>\n          ")}</td>
    </tr>
TR
end

puts <<HEAD
<table>
  <thead>
    <tr style="background:#fffacd;">
      <th width="36%">団体名</th>
      <th>推薦書籍</th>
    </tr>
  </thead>
  <tbody>
HEAD

open(KOF::FILE_OF[:recommend]){|f| KOF::Recommendation.read(f)}
  .group_by{|r| r.gid}
  .sort_by{|g| groups[g.first].name}
  .each_with_index {|(gid, rs), i| tr groups[gid].name, rs.map{|r| books[r.isbn]}, i % 2 == 0}

puts <<FOOT
  </tbody>
</table>
FOOT
