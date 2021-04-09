#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def human_permission(str)
  file_types = { '100' => '-', '040' => 'd', '120' => 'l' }
  permissions = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }
  file_types[str[0, 3]] + permissions[str[3, 1]] + permissions[str[4, 1]] + permissions[str[5, 1]]
end

def puts_files(files)
  files_transposed = files.each_slice(4).map { |file| (file + [nil] * 3)[0...4] }.transpose
  result_files = files_transposed.map { |file| file.map { |file_str| file_str.nil? ? file_str : file_str.ljust(15, ' ') } }
  result_files.each do |result_file|
    puts result_file.join
  end
end

def puts_files_option_l(files)
  total = files.sum { |file| File::Stat.new(file).blocks }
  puts "total #{total}"
  files.each do |file|
    stat = File.stat("./#{file}")
    file_permission = human_permission(stat.mode.to_s(8).rjust(6, '0'))
    user = Etc.getpwuid(stat.uid).name
    group = Etc.getgrgid(stat.gid).name
    update_time = "#{stat.mtime.to_s[6, 1].rjust(2, ' ')} #{stat.mtime.to_s[9, 1].rjust(2, ' ')} #{stat.mtime.to_s[11, 5]}"
    size = stat.size.to_s.rjust(6, ' ')
    puts "#{file_permission}  #{stat.nlink} #{user} #{group} #{size} #{update_time} #{file}"
  end
end

options = ARGV.getopts('a', 'r', 'l')
files = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH).sort : Dir.glob('*').sort
files = files.reverse if options['r']
options['l'] ? puts_files_option_l(files) : puts_files(files)
