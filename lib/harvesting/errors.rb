module Harvesting
  class AuthenticationError < StandardError
  end

  class UnprocessableRequest < StandardError
  end

  class RateLimitExceeded < StandardError
  end
end
