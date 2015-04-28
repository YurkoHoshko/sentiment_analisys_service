module NaiveBayes
  class Persistence

    def self.store(vocabulary)
    end

    def self.serialize(entity, container = {})
      serializeble_fields = entity.class::SERIALIZABLE_ATTRS
      serializeble_fields.each do |field|
        value = entity.send(field)
        if value.is_a? Array
          container[field] = value.map {|child| serialize(child)}
        else
          container[field] = value
        end
      end
      container
    end

    def self.deserialize()

    end
  end

  class Classifier
    attr_accessor :vocabulary

    def initialize(vocabulary)
      @vocabulary = vocabulary
    end

    def train(document_bag_of_words, category_name)
      category = vocabulary.select_category(category_name) || vocabulary.add_category(category_name)
      category.insert_document(document_bag_of_words)
    end

    def classify(document_bag_of_words)
      vocabulary.categories.map do |category|
        category_probability = vocabulary.calculate_category_probability(category)
        category_document_probability = category.calculate_document_probability(document_bag_of_words)
        result = Math.log(category_probability) + category_document_probability

        {
          :category_name => category.name,
          :result => Math::E**result
        }
      end
    end
  end

  class Vocabulary
    SERIALIZABLE_ATTRS = [:name, :categories].freeze
    attr_accessor *SERIALIZABLE_ATTRS

    def initialize(vocabulary_name)
      @name = vocabulary_name
      @categories = []
    end

    def calculate_category_probability(category)
      total_documents_count = categories.map(&:documents_count).reduce(&:+)
      category.documents_count.to_f / total_documents_count.to_f
    end

    def select_category(category_name)
      return if categories.empty?
      categories.select {|category| category.name == category_name}.first
    end

    def add_category(category_name)
      category = Category.new(category_name)
      self.categories << category
      category
    end
  end

  class Category
    SERIALIZABLE_ATTRS = [:name, :tokens, :total_tokens_count, :documents_count].freeze
    attr_accessor *SERIALIZABLE_ATTRS

    def initialize(category_name)
      @name = category_name
      @tokens = []
      @documents_count = 0
      @total_tokens_count = 0
    end

    def insert_document(document_bag_of_words)
      document_bag_of_words.each do |token_name|
        token = find_token(token_name)
        token.update_count
      end
      update_counts(document_bag_of_words.length)
    end

    def calculate_document_probability(document_bag_of_words)
      document_bag_of_words.map do |token|
        token = find_token(token)
        token_probabilty = calculate_token_probability(token)
        Math.log(token_probabilty)
      end.reduce(&:+)
    end

    private

    def find_token(token_name)
      select_token(token_name) || add_token(token_name)
    end

    def select_token(token_name)
      tokens.select {|token| token.name == token_name}.first
    end

    def add_token(token_name)
      token = Token.new(token_name)
      self.tokens << token
      token
    end

    def calculate_token_probability(token)
      token.count.to_f + 1 / (total_tokens_count + tokens.length).to_f  # 1 in numerator and tokens.length in denominator is added because of Laplacian correction
    end

    def update_counts(tokens_count)
      self.documents_count += 1
      self.total_tokens_count += tokens_count
    end
  end

  class Token
    SERIALIZABLE_ATTRS = [:name, :count].freeze
    attr_accessor *SERIALIZABLE_ATTRS

    def initialize(token_name)
      @name = token_name
      @count = 0
    end

    def update_count
      self.count += 1
    end
  end
end