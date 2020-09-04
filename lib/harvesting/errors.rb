module Harvesting
  class AuthenticationError < StandardError
  end

  class UnprocessableRequest < StandardError
  end

  class RequestNotFound < StandardError
    def initialize(uri)
      super("The page you were looking for may have been moved or the address misspelled: #{uri}")
    end
  end

  class RateLimitExceeded < StandardError
  end
end
