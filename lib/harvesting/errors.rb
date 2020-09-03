module Harvesting
  class AuthenticationError < StandardError
  end

  class UnprocessableRequest < StandardError
  end

  class ExceedRateLimit < StandardError
  end
end
