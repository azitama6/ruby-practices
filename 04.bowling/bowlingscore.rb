# frozen_string_literal: true

require 'pry'

# ストライクの計算
def strike_calculator(frames, nextframe)
  # 次のフレームが１０
  if frames[nextframe][0] == 10
    10 + frames[nextframe][0] + frames[nextframe + 1][0]
  # 次のフレームが１０以外
  else
    10 + frames[nextframe].sum
  end
end

getscore = ARGV[0]
scores = getscore.split(',')
scores.map! { |x| x == 'X' ? '10' : x }

shots = []
# スコアを配列に入れる
scores.each do |score|
  # 10だったら０の要素を足す
  if score == '10'
    shots << 10
    shots << 0
  else
    shots << score.to_i
  end
end

frames = []

# 1フレームごとに配列を分ける
shots.each_slice(2) do |s|
  frames << s
end
calc = []
# 現在フレーム数
current_frame = 0
# 1~9フレームはスコア計算あり、１０フレーム以降計算なしで出力
frames.each do |frame|
  current_frame += 1
  nextframe = current_frame
  calc << if frame[0] == 10 && current_frame <= 9
            strike_calculator(frames, nextframe)
          elsif frame.sum == 10 && current_frame <= 9
            10 + frames[nextframe][0]
          else
            frame.sum
          end
end

# 計算結果を出力
puts calc.sum
