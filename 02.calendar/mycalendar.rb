#! /Users/iwasawaryou/.rbenv/shims/ruby
# frozen_string_literal: true

require 'date'
require 'optparse'

today = Date.today
year = today.year
month = today.month

# コマンドラインオプション（-y,-m）と引数のセットをparamsにハッシュとして格納
params = ARGV.getopts('y:m:')
# -yオプションに引数が指定された場合
year = params['y'].to_i if params['y']
# -mオプションに引数が指定された場合
month = params['m'].to_i if params['m']

first_day = Date.new(year, month, 1)
last_day = Date.new(year, month, -1)
first_weekday = first_day.wday

# ヘッダーを表示
puts "#{month}月 #{year}".center(20)
puts '日 月 火 水 木 金 土'
# 曜日に応じて日付の開始地点を調整
print '   ' * first_weekday

# 日付を並べて表示
(first_day..last_day).each do |date|
  if date == today
    print "\x1b[7m#{date.day.to_s.rjust(2)}\x1b[0m "
  else
    print "#{date.day.to_s.rjust(2)} "
  end
  puts if date.saturday?  # 土曜日の場合は改行
end
