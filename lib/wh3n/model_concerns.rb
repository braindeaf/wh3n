module Wh3n
  module ModelConcerns
    extend ActiveSupport::Concern

    included do
      scope :intersects, (lambda do |range|
        where("#{table_name}.starts_at < ?", range.end)
        .where("#{table_name}.ends_at > ?", range.begin)
      end)
    end

    def time_range
      (starts_at..ends_at)
    end

    def duration
      (ends_at - starts_at).seconds
    end

    def intersects(range_or_object)
      range = range_or_object.is_a?(Wh3n::ModelConcerns) ?  range_or_object.time_range : range_or_object

      time_range.begin < range.end && time_range.end > range.begin
    end
  end
end