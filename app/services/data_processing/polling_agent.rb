module Services
  class PollingAgent
    include Celluloid

    MAX_COUNT = 2000

    attr_accessor :counter
    finalizer :process_termination

    def initialize
      @counter = 0
    end

    def poll(research)
      client(research).user(:track => research.keywords) do |object|
        if object.is_a?(Twitter::Tweet)
          SentenceProcessor.new(research.id, object.text).async.process_sentence
          increment_counter
        else
          puts object.inspect
        end
      end
    end

    private

    def client(research)
      user = research.user
      Twitter::Streaming::Client.new do |config|
        config.consumer_key        = TWITTER_CONFIG[:consumer_key]
        config.consumer_secret     = TWITTER_CONFIG[:consumer_secret]
        config.access_token        = user.twitter_access_token
        config.access_token_secret = user.twitter_secret_token
      end
    end

    def increment_counter
      counter < MAX_COUNT ? self.counter += 1 : terminate
    end

    def process_termination
      Actor[:polling_handler].async.start_polling
    end
  end
end