module Errors
  class WentWrong < StandardError; end
  class MissingParameters < StandardError; end
  class DataNotFound < StandardError; end
end