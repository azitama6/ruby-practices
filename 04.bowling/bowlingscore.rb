# frozen_string_literal: true

def calculate_strike(frames, next_frame)
  if frames[next_frame][0] == 10
    10 + frames[next_frame][0] + frames[next_frame + 1][0]
  else
    10 + frames[next_frame].sum
  end
end

scores = ARGV[0].split(',')

shots = []
scores.each do |score|
  if score == 'X'
    shots << 10
    shots << 0
  else
    shots << score.to_i
  end
end

frames = shots.each_slice(2).to_a

results = frames.map.with_index(1) do |frame, next_frame|
  if next_frame <= 9 && frame.sum == 10
    if frame[0] == 10
      calculate_strike(frames, next_frame)
    else
      10 + frames[next_frame][0]
    end
  else
    frame.sum
  end
end

puts results.sum
