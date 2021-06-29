# frozen_string_literal: true

module ThemeCheck
  class HtmlCheck < Check
    extend ChecksTracking
    VARIABLE = /#{Liquid::VariableStart}.*?#{Liquid::VariableEnd}/om.freeze
    START_OR_END_QUOTE = /(^['"])|(['"]$)/.freeze
  end
end
