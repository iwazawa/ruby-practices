#!/usr/bin/env ruby
# frozen_string_literal: true

# 引数を取得して1投ごとに分割
scores = ARGV[0].split(',')

# 1つ1つのショットのスコアを数字に変換する
shots = []
scores.each do |s|
  if s == 'X' # ストライクなら
    shots << 10
    shots << 0
  else # ストライク以外
    shots << s.to_i
  end
end

# フレームごとにまとめる
frames = shots.each_slice(2).to_a

# スコア計算開始
point = 0
frames.each.with_index do |frame, i|
  next_frame = frames[i + 1]
  after_next_frame = frames[i + 2]
  # 9フレームまで
  point +=
    if i < 9
      if frame[0] == 10 # ストライク
        if next_frame[0] == 10 # 次のフレームもストライク
          frame.sum + next_frame[0] + after_next_frame[0]
        else # 次のフレームがストライク以外
          frame.sum + next_frame.sum
        end
      elsif frame.sum == 10 # スペア
        frame.sum + next_frame[0]
      else # それ以外
        frame.sum
      end
    else # 10フレーム目以降
      frame.sum
    end
end

puts point
