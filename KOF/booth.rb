#! /usr/bin/env ruby

require_relative './kof'

module KOF
  using KOF

  class Booth
    def self.open(fn)
      CSV.open(fn, IO_ENCODINGS) do |csv|
        csv.drop(1).inject([]) do |booths, row|
          booths << Booth.new(*row)
        end
      end
    end

    def initialize(group, user, email, abstract, dates, appendix)
      @group, @user, @email, @abstract, @dates, @appendix =
        group.regularize, user.regularize, email, abstract, dates.to_times, appendix
    end

    attr_reader :group, :user, :email, :dates
  end
end

if __FILE__ == $0
  Encoding.default_external = Encoding::UTF_8

  booths = KOF::Booth.open(ARGV[0])

  booths.each do |b|
    p %i[group user email dates].map{|i| b.__send__(i)}
  end
end
