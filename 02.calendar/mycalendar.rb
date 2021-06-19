#! /Users/iwasawaryou/.rbenv/shims/ruby

# 各種ライブラリをrequire
require "date"
require "optparse"
require "paint"

# 各種変数の生成
  # 今日の日付オブジェクトを生成
  today = Date.today
  # yearの初期値設定（今年）
  year = today.year
  # monthの初期値設置（今月）
  month = today.month
# ここまで

# コマンドラインオプションの設定
  # コマンドラインオプション（-y,-m）と引数のセットをparamsにハッシュとして格納
  params = ARGV.getopts("y:m:")
  # -yオプションに引数が指定された場合
  if params["y"]
    year = params["y"].to_i  # 引数を整数に変換してyearに代入
  end
  # -mオプションに引数が指定された場合
  if params["m"]
    month = params["m"].to_i  # 引数を整数に変換してmonthに代入
  end
# ここまで

# 指定された年月の初日、最終日を取得
  # 月の初日をfirst_dayに代入
  first_day = Date.new(year, month, 1)
  # 月の最終日をlast_dayに代入
  last_day = Date.new(year, month, -1)
  # 月の初日の曜日を整数で取得
  first_weekday = first_day.wday
# ここまで

# カレンダー部分の表示
  # 月と年のヘッダーを表示
  puts "#{month}月 #{year}".center(20)
  # 曜日のヘッダーを表示
  puts "日 月 火 水 木 金 土"
  # 曜日に応じて日付の開始地点を調整
  print "   " * first_weekday
  # 日付を並べて表示
  (first_day..last_day).each do |date|
    if date.saturday? # 土曜日なら
      if date == today # 本日なら
        puts Paint[date.day.to_s.rjust(2), :inverse] # 文字と背景を反転して日付を表示（改行あり）
      else  # 本日以外なら
        puts date.day.to_s.rjust(2) # 日付を表示（改行あり）
      end
    else  # 土曜日以外なら
      if date == today  # 本日なら
        print (Paint["#{date.day.to_s.rjust(2)}", :inverse] + " ")  # 文字と背景を反転して日付を表示（改行なし）
      else  # 本日以外なら
        print "#{date.day.to_s.rjust(2)} "  #  日付を表示（改行なし）
      end
    end
  end
# ここまで
