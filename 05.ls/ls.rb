#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'optparse'

opt = OptionParser.new
options = []
opt.on('-a') { options << 'a' }
opt.on('-r') { options << 'r' }
opt.on('-l') { options << 'l' }
opt.parse(ARGV)

def search_file_not_option_a
  Dir.glob('*')
end

def search_file_option_a
  Dir.glob('*', File::FNM_DOTMATCH)
end

def reverse_file_list(files)
  files.reverse!
end

def output_not_option_l(files)
  column_number = 3
  row_number =
    if (files.size % column_number).zero?
      files.size / column_number
    else
      files.size / column_number + 1
    end
  max_length = files.map(&:size).max
  lists = Array.new(row_number) { [] }
  files.each_with_index do |file, index|
    list_number = index % row_number
    file = file.ljust(max_length + 6)
    lists[list_number].push(file)
  end
  lists.each { |list| puts list.join }
end

def file_type(file)
  {
    'file' => '-',
    'directory' => 'd',
    'link' => 'l'
  }[File.ftype(file)]
end

def file_permission(file)
  permission = ''
  fs = File.stat(file).mode.to_s(8)[-3, 3]
  fs.each_char do |s|
    permission +=
      {
        '7' => 'rwx',
        '6' => 'rw-',
        '5' => 'r-x',
        '4' => 'r--',
        '3' => '-wx',
        '2' => '-w-',
        '1' => '--x',
        '0' => '---'
      }[s]
  end
  permission
end

def file_owner(file)
  owner_id = File.stat(file).uid
  Etc.getpwuid(owner_id).name
end

def file_group(file)
  group_id = File.stat(file).gid
  Etc.getgrgid(group_id).name
end

def file_time(file)
  File.stat(file).mtime.strftime('%-m月 %d %R')
end

def file_blocks(file)
  File.stat(file).blocks
end

files =
  if options.include?('a') # aオプション
    search_file_option_a
  else
    search_file_not_option_a
  end

reverse_file_list(files) if options.include?('r') # rオプション

if options.include?('l')
  files_l = files.map do |file|
    [
      file_type(file),
      file_permission(file),
      File.stat(file).nlink.to_s,
      file_owner(file),
      file_group(file),
      File.stat(file).size.to_s,
      file_time(file),
      file
    ]
  end
  total_blocks = files.map { |file| file_blocks(file) }.sum
  puts "total #{total_blocks}"
  files_l.each do |f|
    puts "#{f[0]}#{f[1]} #{f[2].rjust(3)} #{f[3].rjust(12)}  #{f[4]}  #{f[5].rjust(5)} #{f[6].rjust(12)} #{f[7]}"
  end
else
  output_not_option_l(files)
end
