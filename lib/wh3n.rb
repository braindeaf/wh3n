# frozen_string_literal: true

require "active_support"
require_relative "wh3n/version"
require_relative "wh3n/base"
require_relative "wh3n/model_concerns"

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.send :extend, Wh3n::Base
end
