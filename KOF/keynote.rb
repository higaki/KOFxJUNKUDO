#! /usr/bin/env ruby


require_relative './kof'

module KOF
  using KOF

  class Keynote
    def self.open(fn)
      CSV.open(fn, IO_ENCODINGS) do |csv|
        csv.drop(1).inject([]) do |keynotes, row|
          keynotes << Keynote.new(*row)
        end
      end
    end

    def initialize(group, user, email, title, abstract, talker, preferred_date, scale, appendix, room, date)
      @group, @user, @email, @title, @abstract, @talker, @preferred_date, @scale, @appendix, @room, @dates =
        group.regularize, user.regularize, email, title, abstract, talker.regularize, preferred_date.to_times, scale, appendix, room, (date.to_times || [nil, nil])
    end

    def to_hyperlink(id)
    end

    attr_reader :group, :user, :email, :title, :talker, :abstract, :dates
  end
end


if $0 == __FILE__
  Encoding.default_external = Encoding::UTF_8

  keynotes = KOF::Keynote.open(ARGV[0])

  keynotes.each do |k|
    p %i[group talker title dates].map{|i| k.__send__(i)}
  end
end
