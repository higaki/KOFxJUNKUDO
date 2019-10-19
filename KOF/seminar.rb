#! /usr/bin/env ruby

require_relative './kof'

module KOF
  using KOF

  class Seminar
    def self.open(fn)
      CSV.open(fn, IO_ENCODINGS) do |csv|
        csv.inject([]) do |seminars, row|
          seminars << Seminar.new(*row)
        end
      end
    end

    def initialize(group, user, email, title, abstract, talker, preferred_date, scale, appendix, room, date)
      @group, @user, @email, @title, @abstract, @talker, @preferred_date, @scale, @appendix, @room, @dates =
        group.regularize, user.regularize, email, title, abstract, talker, preferred_date.to_times, scale, appendix, room, date.to_times
    end

    def to_hyperlink(id)
      ds = dates.all?(&:nil?) ? preferred_date : dates
      ds.map do |d|
        %Q|=HYPERLINK("#{[URL_BASE, id].join('/')}", "#{d.strftime('%H:%M')}")| if d
      end
    end

    attr_reader :group, :user, :email, :title, :abstract, :preferred_date, :dates
  end
end

if __FILE__ == $0
  Encoding.default_external = Encoding::UTF_8

  seminars = KOF::Seminar.open(ARGV[0])

  seminars.each do |b|
    p %i[group user email dates].map{|i| b.__send__(i)}
  end
end
