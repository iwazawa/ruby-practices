# frozen_string_literal: true

require 'optparse'

def main
  params = ARGV.getopts('l')
  ARGV.empty? ? standard_input(params['l']) : file_input(params['l'], ARGV)
end

def standard_input(lines)
  contents = $stdin.read
  lines_count = contents.split("\n").size.to_s.rjust(8)
  words_count = contents.split.size.to_s.rjust(8)
  size = contents.bytesize.to_s.rjust(8)
  lines ? puts(lines_count) : puts("#{lines_count}#{words_count}#{size}")
end

def file_input(lines, files)
  files_stats = build_stat(files)
  loop_count = 0
  files_stats.each do |stats|
    loop_count += 1
    if stats.instance_of?(Array)
      stats.slice!(1, 2) if lines
      puts stats.join
    else
      puts stats
    end
  end
  cal_total(lines, files_stats) if loop_count > 1
end

def build_stat(files)
  files.map do |file|
    if File.stat(file).directory?
      "wc: #{file}: read: Is a directory"
    else
      [
        IO.readlines(file).size.to_s.rjust(8),
        IO.read(file).split.size.to_s.rjust(8),
        File.stat(file).size.to_s.rjust(8),
        " #{file}"
      ]
    end
  rescue SystemCallError
    "wc: #{file}: open: No such file or directory"
  end
end

def cal_total(lines, files_stats)
  total_lines_count = 0
  total_words_count = 0
  total_file_size = 0
  files_stats.each do |stats|
    next unless stats.instance_of?(Array)

    total_lines_count += stats[0].to_i
    total_words_count += stats[1].to_i
    total_file_size += stats[2].to_i
  end
  if lines
    puts "#{total_lines_count.to_s.rjust(8)} total"
  else
    puts "#{total_lines_count.to_s.rjust(8)}#{total_words_count.to_s.rjust(8)}#{total_file_size.to_s.rjust(8)} total"
  end
end

main
