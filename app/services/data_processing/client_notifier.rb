module Services
  class ClientNotifier
    include Celluloid
    include Celluloid::Notifications

    attr_reader :research_id, :socket

    def initialize(research_id, socket)
      @research_id = research_id
      @socket = socket
    end

    def subscribe_to_research
      subscribe("research_#{research_id}", :send_notification)
      Actor[:polling_handler].start_polling
    end

    def send_notification(topic, data)
      socket.send("#{topic}, #{data}")
    end

  end
end