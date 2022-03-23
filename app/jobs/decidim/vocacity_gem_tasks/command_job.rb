require "rake"
module Decidim
  module VocacityGemTasks
    class CommandJob < ApplicationJob
      attr_reader :logger, :variables, :command_name
      def perform(command_name, variables = {}, logger = Rails.logger)
        @command_name = command_name
        @variables = variables
        @logger = logger
        invoke!
      end

      private

        def invoke!
          raise Decidim::VocacityGemTasks::Error unless valid?
          ::Rake::Task["vocacity:#{command_name}"].invoke(task_args)
        end

        def task_args
          variables.reduce([]) do |acc, (key, value)|
            acc << "#{key}=\"#{value}\""
          end.join(" ") unless variables.empty?
        end

        def valid?
          Rake::Task["vocacity:#{command_name}"]
          true
        rescue RuntimeError
          false
        end
    end
  end
end
