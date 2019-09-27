#! /usr/bin/env ruby

require_relative './KOF/booth'
require_relative './KOF/seminar'
require_relative './KOF/user'

Encoding.default_external = Encoding::UTF_8

include KOF

booth_fn   = ARGV[0]
seminar_fn = ARGV[1]

booths   = Booth  .open(booth_fn)
seminars = Seminar.open(seminar_fn)

users = open(KOF::FILE_OF[:user]){|f|User::read(f)} rescue {}

(booths + seminars).each do |b|
  u = User.new(b.user, b.email)
  next if users.include? u.email
  u.id = gen_id(users, 1)
  users[u.email] = u
end

open(KOF::FILE_OF[:user], "w") do |f|
  f.puts users.values.sort_by(&:id).map{|u|%i[id name email].map{|i|u.__send__ i}.join("\t")}
end
