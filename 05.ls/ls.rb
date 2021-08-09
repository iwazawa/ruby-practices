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

files = []

# -aオプション以外のファイル一覧取得用
def get_file_not_option_a(files)
  Dir.foreach('.') do |file|
    next if file.match?(/^\.\w*/)

    files << file
  end
  files.sort!
end

# -aオプション指定時のファイル一覧取得用
def get_file_option_a(files)
  Dir.foreach('.') do |file|
    files << file
  end
  files.sort!
end

# -rオプション指定時のファイル一覧反転用
def reverse_file_list(files)
  files.reverse!
end

# -lオプション以外の出力用
def output_not_option_l(files)
  # 3つにグルーピング
  grouped_items = []
  files.each_slice(files.size / 3 + 1) do |file|
    grouped_items << file
  end
  # 各配列のn番目の要素ごとに配列を再構成
  lists = []
  grouped_items.each do |grouped_item|
    grouped_item.each.with_index do |file, i|
      lists[i] = [] if lists[i].nil?
      lists[i] << file
    end
  end
  lists.each do |list|
    list.each do |file|
      print file.ljust(20)
    end
    puts
  end
end

# ファイルタイプ取得
def get_file_type(file)
  {
    'file' => '-',
    'directory' => 'd',
    'link' => 'l'
  }[File.ftype(file)]
end

# パーミッション取得
def get_file_permission(file)
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

# オーナー名取得
def get_file_owner(file)
  owner_id = File.stat(file).uid
  Etc.getpwuid(owner_id).name
end

# グループ名取得
def get_file_group(file)
  group_id = File.stat(file).gid
  Etc.getgrgid(group_id).name
end

# タイムスタンプ取得
def get_file_time(file)
  File.stat(file).mtime.strftime('%-m月 %d %R')
end

# ブロック数取得
def get_file_blocks(file)
  File.stat(file).blocks
end

if options.include?('a') # aオプション
  get_file_option_a(files)
else
  get_file_not_option_a(files)
end

reverse_file_list(files) if options.include?('r') # rオプション

files_l = []
total_blocks = 0
if options.include?('l')
  files.each do |file|
    filetype = get_file_type(file)
    permission = get_file_permission(file)
    owner_name = get_file_owner(file)
    group_name = get_file_group(file)
    timestamp = get_file_time(file)
    total_blocks += get_file_blocks(file)

    files_l <<
      {
        type: filetype,
        perm: permission,
        link: File.stat(file).nlink.to_s,
        owner: owner_name,
        group: group_name,
        size: File.stat(file).size.to_s,
        time: timestamp,
        name: file
      }
  end

  puts "total #{total_blocks}"
  files_l.each do |f|
    puts "#{f[:type]}#{f[:perm]} #{f[:link].rjust(3)} #{f[:owner].rjust(12)}  #{f[:group]}  #{f[:size].rjust(5)} #{f[:time].rjust(12)} #{f[:name]}"
  end
else
  output_not_option_l(files)
end
