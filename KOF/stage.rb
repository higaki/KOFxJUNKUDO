#! /usr/bin/env ruby

require_relative './kof'

module KOF
  using KOF

  class Stage
    def self.open(fn)
      CSV.open(fn, IO_ENCODINGS) do |csv|
        csv.drop(1).inject([]) do |stages, row|
          stages << Stage.new(*row)
        end
      end
    end

    def initialize(group, user, email, title, abstract, talker, preferred_date, scale, appendix, date, min)
      @group, @user, @email, @title, @abstract, @talker, @preferred_date, @scale, @appendix, @dates, @min =
        group.regularize, user.regularize, email, title, abstract, talker, preferred_date.to_times, scale, appendix, (date.to_times || [nil, nil]), min
    end

    def to_hyperlink(id)
      dates.map do |d|
        %Q|=HYPERLINK("#{[URL_BASE, id].join('/')}", "#{d.strftim}")| if d
      end
    end

    attr_reader :group, :user, :email, :title, :talker, :dates, :min
  end
end

if $0 == __FILE__
  Encoding.default_external = Encoding::UTF_8

  stages = KOF::Stage.open(ARGV[0])

  stages.each do |s|
    p %i[group user email title talker dates min].map{|i| s.__send__(i)}
  end
end
