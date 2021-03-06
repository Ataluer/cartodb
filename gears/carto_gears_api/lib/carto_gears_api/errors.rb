module CartoGearsApi
  module Errors
    # Thrown when an object could not be found in the database
    class RecordNotFound < StandardError
      def initialize(object, id)
        super("Could not find #{object} with id #{id}")
      end
    end

    # Thrown when trying to set invalid values for an object
    class ValidationFailed < StandardError
      # @return [Hash<String, Array<String>>] A hash with incorrect attributes as keys and array of messages as values
      attr_reader :errors

      def initialize(errors)
        super(errors)
        @errors = errors
      end
    end
  end
end
