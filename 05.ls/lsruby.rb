#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def witch_permmisiion?(str)
  file_types = {
    '100' => '-',
    '040' => 'd',
    '120' => 'l'
  }
  permmisions = {
    '0'	=> '---',
    '1'	=> '--x',
    '2'	=> '-w-',
    '3'	=> '-wx',
    '4'	=> 'r--',
    '5'	=> 'r-x',
    '6'	=> 'rw-',
    '7'	=> 'rwx'
  }
  file_types[str[0, 3]] + permmisions[str[3, 1]] + permmisions[str[4, 1]] + permmisions[str[5, 1]]
end

def puts_files(files)
  files_transposed = files.each_slice(4).map { |file| (file + [nil] * 3)[0...4] }.transpose
  result_files = files_transposed.map { |file| file.map { |file_str| file_str.nil? ? file_str : file_str.ljust(15, ' ') } }
  result_files.each do |result_file|
    puts result_file.join
  end
end

def puts_option_a(multiple_option_flag)
  all_files = Dir.glob('*', File::FNM_DOTMATCH).sort
  if multiple_option_flag
    all_files
  else
    puts_files(all_files)
  end
end

def puts_option_r(multiple_option_flag, result_files)
  if multiple_option_flag
    result_files.reverse
  else
    reversed_files = Dir.glob('*').sort.reverse
    puts_files(reversed_files)
  end
end

def puts_option_l(multiple_option_flag, result_files)
  list_files = multiple_option_flag ? result_files : Dir.glob('*').sort
  total = list_files.sum { |file| File::Stat.new(file).blocks }
  puts "total #{total}"
  list_files.each do |list_file|
    stat = File.stat("./#{list_file}")
    file_permission = witch_permmisiion?(stat.mode.to_s(8).rjust(6, '0'))
    user = Etc.getpwuid(stat.uid).name
    group = Etc.getgrgid(stat.gid).name
    update_time = "#{stat.mtime.to_s[6, 1].rjust(2, ' ')} #{stat.mtime.to_s[9, 1].rjust(2, ' ')} #{stat.mtime.to_s[11, 5]}"
    size = stat.size.to_s.rjust(6, ' ')
    puts "#{file_permission}  #{stat.nlink} #{user} #{group} #{size} #{update_time} #{list_file}"
  end
end
input_args = ARGV.map { |input_arg| input_arg.delete('-') }.join.chars.map { |arg| "-#{arg}" }
option_args = []
option_args << '-a' if input_args.include?('-a')
option_args << '-r' if input_args.include?('-r')
option_args << '-l' if input_args.include?('-l')
multiple_option_flag = option_args.size > 1

result_files = Dir.glob('*').sort
opt = OptionParser.new
opt.on('-a') { result_files = puts_option_a(multiple_option_flag) }
opt.on('-r') { result_files = puts_option_r(multiple_option_flag, result_files) }
opt.on('-l') { result_files = puts_option_l(multiple_option_flag, result_files) }
opt.parse(option_args)
puts_files(result_files) if option_args.empty?
puts_files(result_files) if multiple_option_flag && !option_args.include?('-l')
