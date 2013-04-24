require "acts-as-taggable-on"
require "paper_trail"
require "squeel"

class Question < ActiveRecord::Base
  CATEGORIES = %w[boolean choice association image text]

  belongs_to :quiz

  acts_as_taggable
  has_paper_trail on: [:destroy]
  serialize :data, Hash

  scope :ascending, -> { order{created_at.asc} }

  validates :content, presence: true

  def self.data_accessor(*keys)
    keys.each do |key|
      define_method(key) do
        (data || {})[key]
      end

      define_method("#{key}=") do |value|
        self.data = (data || {}).merge(key => value)
      end
    end
  end

  def dup
    super.tap do |question|
      question.tag_list = self.tag_list
    end
  end
end
