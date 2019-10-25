#! /usr/bin/env ruby

require_relative './KOF/group'
require_relative './KOF/booth'
require_relative './KOF/seminar'
require_relative './KOF/stage'

Encoding.default_external = Encoding::UTF_8

seminars = KOF::Seminar.open(ARGV[1])
booths   = KOF::Booth  .open(ARGV[0])
stages   = KOF::Stage  .open(ARGV[2])

def days(x)
  return [nil, nil] if x.nil?
  x.dates.map{|d| "○" if d}
end

def times(x)
  return [nil, nil] if x.nil?
  x.dates.map{|d| d.strftime('%H:%M') if d}
end

def tsv(xs, bs, n = 1)
  xs.sort_by{|x| x.dates.reject(&:nil?)}.each_with_index do |x, i|
    puts [
      i + n,
      x.group,
      %Q|"#{x.abstract}"|,
      bs.has_key?(x.group)? days(bs[x.group]) : [nil, nil],
      x.kind_of?(KOF::Seminar)? times(x) : [nil, nil],
      x.kind_of?(KOF::Stage  )? times(x) : [nil, nil],
    ].join("\t")
  end

  xs.size
end

indexes = {}
[seminars, stages].each do |xs|
  indexes = xs.inject(indexes){|ss, s| ss[s.group] = s; ss}
end

bindex = booths.inject({}){|bs, b| bs[b.group] = b; bs}

n = tsv(seminars + stages, bindex)
tsv(booths.reject{|b| indexes.has_key? b.group}, bindex, n + 1)
