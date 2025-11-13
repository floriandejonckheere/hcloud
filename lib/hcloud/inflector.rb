# frozen_string_literal: true

module HCloud
  class Inflector < Zeitwerk::Inflector
    def underscore(classname)
      classname
        .to_s
        .split("::")
        .map { |word| overrides.key(word) || word.underscore }
        .join("/")
    end
  end
end
