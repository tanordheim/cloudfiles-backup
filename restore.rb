#!/usr/bin/env ruby

require 'rubygems'
require 'date'
require File.join(File.expand_path(File.dirname(__FILE__)), 'lib', 'cloudfiles-backup')

#
# Restore the file specified in the comandline arguments from the configured
# CloudFiles container.
#

def usage
  puts "Usage: restore.rb [date] [filename]"
  exit 1
end

date = ARGV[0]
filename = ARGV[1]
if date.nil? || date.strip == '' || date !~ /^\d{4}-\d{2}-\d{2}$/
  usage
end
if filename.nil? || filename.strip == ''
  usage
end

container = CloudFilesBackup::Container.new
container.restore!(Date.parse(date), filename)
