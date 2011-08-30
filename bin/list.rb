#!/usr/bin/env ruby

require 'rubygems'
require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib', 'cloudfiles-backup')

#
# Lists all files currently stored within the configuredCloudFiles container.
#

container = CloudFilesBackup::Container.new
container.available_backups.each do |backup|
  puts "-> [#{backup.date.strftime('%Y-%m-%d')}] #{backup.filename}"
end
