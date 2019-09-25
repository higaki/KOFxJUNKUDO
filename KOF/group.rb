#! /usr/bin/env ruby

module KOF
  class Group
    def initialize(name, email, id = nil, booth = nil, seminar = nil, junku = nil)
      @id, @name, @email, @booth, @seminar, @junku =
        id, name, email, booth, seminar, junku
    end

    def key
      [name, email]
    end

    attr_accessor *%i[id name email booth seminar junku]

    def self.read(fn)
      open(fn, &:readlines)
        .map{|l| l.strip.split(/\t/)}
        .map{|id, name, email, booth, seminar, junku|
            booth   = nil  if booth&.empty?
            seminar = nil  if seminar&.empty?
            junku   = nil  if junku&.empty?
            KOF::Group.new(name, email, id.to_i, booth, seminar, junku)}
        .inject({}){|gs, g| gs[g.key] = g; gs}
    rescue SystemCallError
      {}
    end
  end
end
