# encoding: utf-8

module CloudFilesBackup #:nodoc

  # Holds the configuration values.
  class Config

    CONFIG_FILE_NAME = 'cloudfiles-backup.conf'

    attr_accessor :username, :api_key, :auth_location, :container, :use_service_net, :retention_days

    # Initialize the configuration. This will read the configuration values from
    # the configuration file.
    def initialize

      # Set some defaults
      self.auth_location = 'usa'
      self.use_service_net = 'false'
      self.retention_days = 7

      config_file = find_config_file
      raise "Unable to find configuration file" if config_file.nil?

      File.open(config_file, 'r') do |file|
        while (line = file.gets)
          key, value = line.strip.split('=', 2)
          send(:"#{key}=", value)
        end
      end

    end

    # Returns true if we're configured to use the Rackspace service network.
    def use_service_net?
      self.use_service_net == 'true'
    end

    # Returns the auth URL for the CloudFiles API.
    def auth_url
      CloudFiles.const_get("AUTH_#{self.auth_location.upcase}")
    end

    # Returns the number of days to keep backed up files before removing them. A
    # value of 0 keeps the files forever.
    def retention_days
      @retention_days.nil? ? 0 : @retention_days.to_i
    end

    private

    # Find the configuration file to use. The file must be named
    # cloudfiles-backup.conf.
    #
    # This first checks the root directory of the application. If it can't find
    # it there, checks in /etc.
    def find_config_file

      root_directory = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
      app_config = File.join(root_directory, CONFIG_FILE_NAME)
      global_config = File.join('/etc', CONFIG_FILE_NAME)

      [app_config, global_config].each do |config_file|
        return config_file if File.exists?(config_file)
      end

      nil

    end

  end

end
