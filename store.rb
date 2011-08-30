#!/usr/bin/env ruby

require 'rubygems'
require File.join(File.expand_path(File.dirname(__FILE__)), 'lib', 'cloudfiles-backup')

#
# Store the file specified in the commandline arguments within the configured
# CloudFiles container.
#

file = ARGV[0]
if file.nil? || file.strip == '' || !File.exists?(file)
  puts "Usage: store.rb [path to file]"
  exit 1
end

container = CloudFilesBackup::Container.new
container.purge_old_backups!
container.store!(file)
