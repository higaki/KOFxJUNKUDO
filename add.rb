#! /usr/bin/env ruby

require_relative './KOF/kof'
require_relative './KOF/book'

Encoding.default_external = Encoding::UTF_8

books = open(KOF::FILE_OF[:book]){|f| KOF::Book.read(f)}

ARGV.each{|isbn| KOF::Book.add(isbn.strip, books)}

open(KOF::FILE_OF[:book], 'w') do |f|
  books.each do |_, b|
    f.puts [b.isbn, b.title, b.url].join("\t")
  end
end

