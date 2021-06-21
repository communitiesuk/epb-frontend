module Helper
  module ResponseLogging
    def self.log_if_error(&block)
      response = yield block
      if response.status == 401
        logger = Logger.new($stdout)
        logger.log(Logger::ERROR, "401 response received from internal API with body: %s" % response.body)
      end

      response
    end
  end
end
