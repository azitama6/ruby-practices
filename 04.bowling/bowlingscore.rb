# frozen_string_literal: true

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
nowframe = 0

# 1~9フレームはスコア計算あり、１０フレーム以降計算なしで出力
frames.each do |frame|
  nowframe += 1
  nextframe = nowframe + 1
  if frame[0] == 10 && nowframe <= 9
    10 + frames[nextframe].sum
  elsif frame.sum == 10 && nowframe <= 9
    10 + frames[nextframe][0]
  else
    frame.sum
  end
  calc << points
end
puts calc.sum
