#! /usr/bin/env ruby

require_relative './kof'

module KOF
  using KOF

  class Seminar < Kof
    def self.open(fn)
      CSV.open(fn, @@io) do |csv|
        csv.inject([]) do |seminars, row|
          seminars << Seminar.new(*row)
        end
      end
    end

    def initialize(group, user, email, title, abstract, talker, preferred_date, scale, appendix,date, room)
      @group, @user, @email, @title, @abstract, @talker, @preferred_date, @scale, @appendix, @date, @room =
        group.regularize, user.regularize, email, title, abstract, talker, preferred_date.to_times, scale, appendix, date.to_times, room
    end

    attr_reader :group, :user, :email, :preferred_date
  end
end

if __FILE__ == $0
  Encoding.default_external = Encoding::UTF_8

  seminars = KOF::Seminar.open(ARGV[0])

  seminars.each do |b|
    p %i[group user email preferred_date].map{|i| b.__send__(i)}
  end
end
