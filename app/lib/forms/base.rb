require "active_model"
module Forms
  class Base
    include Virtus.model
    include ActiveModel::Validations

    def model_fields
      []
    end

    def model_attributes
      attributes.slice(*model_fields)
    end
  end
end