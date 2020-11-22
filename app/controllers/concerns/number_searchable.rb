module NumberSearchable
  extend ActiveSupport::Concern

  included do
    scope :search_by_number, -> (value) do
      self.find_by("number = ?", "#{value}")
      # self.find_by(number: "#{value}")
    end
  end
end