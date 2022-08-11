module Decidim
  module Voca
    module Organization
      class UpdateOrganizationCommand < Rectify::Command
        def organization
          @organization ||= ::Decidim::Organization.first
        end
        def self.command_name
          name.demodulize.camelize.stub(/_command/, "")
        end
        def command_name
          self.command_name
        end
      end
    end
  end
end
