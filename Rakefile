$LOAD_PATH.push(__dir__)

require 'yaml'
require 'oauth2'
require 'nkf'
require 'date'
require 'pry'

task_dir = "#{__dir__}/lib/tasks/"
root_dir = Dir.pwd
Dir.chdir task_dir
Dir.entries('.').select{ |entry| entry =~ /\.rake\Z/ }.each do |entry|
  load "#{task_dir}#{entry}"
end
Dir.chdir root_dir


