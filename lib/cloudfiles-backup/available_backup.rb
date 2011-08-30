module CloudFilesBackup #:nodoc

  # Defines an available backup within the configured container.
  class AvailableBackup

    attr_accessor :date, :filename

    # Initialize a new available backup definition.
    def initialize(*args)
      args.first.each do |key, value|
        send(:"#{key}=", value)
      end
    end
    
  end

end
