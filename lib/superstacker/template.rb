require 'superstacker/primitives'

module SuperStacker
  module Template
    class Template
      AWSTemplateFormatVersion = "2010-09-09"

      def initialize(spec)
        @spec = spec
        @root = {
          "AWSTemplateFormatVersion" => AWSTemplateFormatVersion
        }
      end

      def compile
        instance_eval(@spec, 'spec.rb', 0)
        @root
      end

      def description(desc)
        @root["Description"] = desc
      end

      def resource(name, type, &block)
        res = Resource.new(name, type, &block)

        @root["Resources"] ||= {}
        @root["Resources"][res.name] = res
      end

      def mapping(name, &block)
        map = Mapping.new(name, &block)

        @root["Mappings"] ||= {}
        @root["Mappings"][map.name] = map
      end

      def parameter(name, opts = {})
        raise "Type parameter is required!" unless opts.include? "Type"

        @root["Parameters"] ||= {}
        @root["Parameters"][name] = opts
      end

      def output(name, value, description = nil)
        output = { "Value" => value }
        output["Description"] = description unless description.nil?

        @root["Outputs"] ||= {}
        @root["Outputs"][name] = output
      end
    end
  end
end
