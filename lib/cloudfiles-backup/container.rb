# encoding: utf-8

require 'cloudfiles'
require 'date'

module CloudFilesBackup #:nodoc

  OBJECT_DATE_REGEXP = /^\[(\d{4}-\d{2}-\d{2})\]_/

  # Lists, stores and restores files from the configured Rackspace CloudFiles
  # container.
  class Container

    # Initialize the CloudFiles Backup class.
    def initialize
      @config = Config.new
    end

    # Store a file in the container
    def store!(file_path)

      filename = File.basename(file_path)
      file = File.open(file_path, 'r')

      object_name = "[#{Date.today.strftime('%Y-%m-%d')}]_#{filename}"
      object = container.create_object(object_name)
      object.write(file)

      file.close

    end

    # Restore a file from the container
    def restore!(date, filename)

      object_name = "[#{date.strftime('%Y-%m-%d')}]_#{filename}"
      unless container.object_exists?(object_name)
        raise "Object #{object_name} not found in container."
      end
      if File.exists?(filename)
        raise "File #{filename} already exists locally, not overwriting."
      end

      object = container.object(object_name)
      object.save_to_filename(filename)

    end

    # Purge all backed up files older than the number of days set in the
    # configuration.
    def purge_old_backups!

      return if @config.retention_days == 0

      today = Date.today

      # Iterate through all objects in the container. When backups are stored,
      # they are stored with the filename [<backup date>]_<original filename>,
      # so we based our purging on the dates parsed from the filename.
      objects = container.objects
      objects.each do |object_name|
        if object_name =~ OBJECT_DATE_REGEXP

          object_date = Date.parse($1)
          object_age = (today - backup_date).to_i
          puts "Found object #{object_name}, #{object_age} days old based on date #{object_date}"

          if object_age > @config.retention_days

            # TODO - delete item

          end

        end
      end

    end

    # Returns an array of all available backups in the container, sorted
    # descending by backup date.
    def available_backups

      backups = []

      objects = container.objects
      objects.each do |object_name|
        if object_name =~ OBJECT_DATE_REGEXP

          object_date = Date.parse($1)
          filename = file_name_from_object_name(object_name)
          backups << AvailableBackup.new(:date => object_date, :filename => filename)

        end
      end

      backups.sort { |a, b| b.date <=> a.date }

    end

    private

    # Returns the CloudFiles container used to store files.
    def container
      @container ||= find_or_create_container
    end

    # Find the CloudFiles container used to store files, and create it if it
    # doesn't already exists.
    def find_or_create_container
      unless connection.container_exists?(@config.container)
        connection.create_container(@config.container)
      end
      connection.container(@config.container)
    end

    # Configures and returns the CloudFiles connection.
    def connection
      @connection ||= CloudFiles::Connection.new(:username => @config.username, :api_key => @config.api_key, :auth_url => @config.auth_url, :snet => @config.use_service_net?)
    end

    # Returns the actual filename from a container object name.
    def file_name_from_object_name(object_name)
      object_name.gsub(OBJECT_DATE_REGEXP, '')
    end

  end

end
