#! /usr/bin/env ruby

module KOF
  class User
    def initialize(name, email, id = nil)
      @name, @email, @id = name, email, id
    end

    attr_accessor :name, :email, :id

    def self.read(fn)
      open(fn, &:readlines)
        .map{|l| l.strip.split(/\t/)}
        .map{|id, name, email| KOF::User.new(name, email, id.to_i)}
        .inject({}){|us, u| us[u.email] = u; us}
    rescue SystemCallError
      {}
    end
  end
end
