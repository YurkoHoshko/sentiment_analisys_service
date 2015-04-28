require 'celluloid/autostart'
module Services
  class SentenceProcessor
    include Celluloid
    include Celluloid::Notifications

    attr_reader :research_id, :sentence

    def initialize(research_id, sentence)
      @sentence = sentence
      @research_id = research_id
    end

    def process_sentence
      # sentiment_result_future = SentimentAnalizer.new(sentence).future.classify
      # research_future = Actor[:sentence_persistence_handler].future.persist_for_research(research_id, sentence, sentiment_result_future)
      # data = prepare_payload(research_id)
      publish("research_#{research_id}", "#{research_id}, #{sentence}")

      terminate
    end

    private

    def prepare_payload(research_future)
      research = research_future.value
      {
        :research_id => research.id
      }
    end
  end
end