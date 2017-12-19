module ACH
  class Error < RuntimeError; end
  class InvalidError < Error; end
  class UnrecognizedTypeCode < Error; end
end
