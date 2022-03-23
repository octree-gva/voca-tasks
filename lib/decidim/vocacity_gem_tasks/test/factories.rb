# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :vocacity_gem_tasks_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :vocacity_gem_tasks).i18n_name }
    manifest_name :vocacity_gem_tasks
    participatory_space { create(:participatory_process, :with_steps) }
  end

  # Add engine factories here
end
