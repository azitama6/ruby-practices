# frozen_string_literal: true

require 'optparse'
require 'etc'

def directory?(file)
  File.directory?(file)
end

def output_dir(file)
  puts "wc: #{file}: read: Is a directory"
end

def count_words(file)
  line = file.count("\n")
  word = file.split(/\s+/).size
  byte = file.bytesize
  [line, word, byte]
end

def output_count(files, option)
  files.each do |file|
    print file[0].to_s.rjust(8)
    print file[1].to_s.rjust(8) unless option['l']
    print file[2].to_s.rjust(8) unless option['l']
    puts "\s#{file[3]}"
  end
end

def output_total_count(total, option, std_flg)
  print total[0].to_s.rjust(8)
  print total[1].to_s.rjust(8) unless option['l']
  print total[2].to_s.rjust(8) unless option['l']
  puts std_flg ? "\n" : "\stotal"
end

def read_files(file)
  File.read(file)
end

def culculate_arguments(files)
  result = []
  total = []
  files.each do |file|
    if directory?(file)
      output_dir(file)
    else
      result << count_words(read_files(file))
    end
  end
  result.transpose.each do |transposed_result|
    total << transposed_result.sum
  end
  files.each do |file|
    result = result.map { |array| array.push(file) }
  end
  { result: result, total: total }
end

def culculate_standard_input(files)
  result = []
  total = []
  files.each do |file|
    result << count_words(file)
  end
  result.transpose.each do |transposed_result|
    total << transposed_result.sum
  end
  { result: result, total: total }
end

def main
  option = ARGV.getopts('l')
  std_in_flg = false

  if ARGV.empty?
    std_in_flg = true
    count_std_words = culculate_standard_input(readlines)
    output_total_count(count_std_words[:total], option, std_in_flg) if count_std_words[:result].size > 1
  else
    count_words = culculate_arguments(ARGV)
    output_count(count_words[:result], option)
    output_total_count(count_words[:total], option, std_in_flg) if count_words[:result].size > 1
  end
end

main
