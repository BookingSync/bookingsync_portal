# Required for Rails 5 until https://github.com/thoughtbot/shoulda-matchers/pull/965 get merged.

if Gem.loaded_specs["shoulda-matchers"].version.to_s != "2.8.0"
  puts "\n\n\n"
  puts "------------------------------------------------------------------------------"
  puts "WARNING, the following file might no longer be required or need to be adjusted"
  puts "------------------------------------------------------------------------------"
  puts "File: #{__FILE__}"
  puts "PR required to be merged: https://github.com/thoughtbot/shoulda-matchers/pull/965"
  puts "\n\n\n"
  exit
end

module Shoulda
  module Matchers
    RailsShim.class_eval do
      def self.serialized_attributes_for(model)
        if defined?(::ActiveRecord::Type::Serialized)
          # Rails 5+
          model.columns.select do |column|
            model.type_for_attribute(column.name).is_a?(::ActiveRecord::Type::Serialized)
          end.inject({}) do |hash, column|
            hash[column.name.to_s] = model.type_for_attribute(column.name).coder
            hash
          end
        else
          model.serialized_attributes
        end
      end
    end
  end
end
