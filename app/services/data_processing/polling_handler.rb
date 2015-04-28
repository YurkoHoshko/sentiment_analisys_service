module Services
  class PollingHandler
    include Celluloid
    Research = Struct.new(:id, :keywords, :user)
    User = Struct.new(:id, :username, :twitter_access_token, :twitter_secret_token)

    def start_polling
      research = select_research
      Actor[:polling_agent].poll(research)
    end

    private
    def select_research
      user = User.new(1, "Yura", TWITTER_CONFIG[:oauth_token], TWITTER_CONFIG[:oauth_secret])
      research = Research.new(1, %w(ruby rails matz).join(","), user)
    end
  end
end