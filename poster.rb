#! /usr/bin/env ruby

require_relative './KOF/group'
require_relative './KOF/book'
require_relative './KOF/recommend'
require_relative './KOF/booth'

Encoding.default_external = Encoding::UTF_8

include KOF
using KOF

group_by_key = open(FILE_OF[:group], **IO_ENCODINGS) {|f| Group.read(f)}
group_by_id  = group_by_key.values.inject({}){|gs, g| gs[g.id] = g; gs}

books = open(FILE_OF[:book], **IO_ENCODINGS) {|f| Book.read(f)}

recommends =
  open(FILE_OF[:recommend], **IO_ENCODINGS) {|f| Recommendation.read(f)}

booth_of = Booth.open(ARGV[0]).inject({}){|bs, b| bs[b.group] = b; bs}

def head
  puts <<-EO_HEAD
\\documentclass[14pt,mingoth]{jsarticle}
\\usepackage[dvipdfm]{graphicx,color}

\\pagestyle{empty}

\\setlength{\\voffset}{-0.5in}
\\setlength{\\hoffset}{-0.5in}

\\setlength{\\textheight}{176mm}
\\setlength{\\textwidth}{135mm}

\\begin{document}
\\LARGE
  EO_HEAD
end

def body group, recommend
  name = group.name
  size = name.size > 15 ? "\\huge" : "\\Huge"
  isbn = recommend.isbn.isbn
  author = recommend.author&.empty? ? "" : recommend.author ? "\n\n\\vspace{1ex}\\hfill\\textcolor{red}{\\textbf{\\Huge サイン会開催}}" : ""
  $stderr.puts [name, recommend.author].join("\t")
  puts <<-EOF
\\textbf{#{size} #{name}} 推薦#{author}
\\begin{center}
\\vfill
\\includegraphics[height=10cm]{#{isbn}.jpg}
\\vfill
\\vfill
\\includegraphics[height=8mm]{logo.pdf}
\\end{center}
\\pagebreak
  EOF
end

def foot
  puts '\\end{document}'
end

head

recommends.each do |r|
  g = group_by_id[r.gid]
  body(g, r) if g && booth_of[g.name]
end

foot
