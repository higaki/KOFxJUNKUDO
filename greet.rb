#! /usr/bin/env ruby

require_relative './KOF/user'
require_relative './KOF/group'

Encoding.default_external = Encoding::UTF_8

group_fn = "groups.tsv"
user_fn  = "users.tsv"

groups = open(group_fn){|f| KOF::Group.read(f)} # rescue {}
users  = open(user_fn ){|f| KOF::User .read(f)} # rescue {}

def greet(group, user)
  fn = "#{group.id}.txt"
  puts [fn, group.email, group.name, user.name].join("\t")
end

groups.values.each do |group|
  greet(group, users[group.email])
end
