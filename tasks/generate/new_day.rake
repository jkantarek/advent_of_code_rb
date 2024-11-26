# frozen_string_literal: true

require_relative "../helpers"

namespace :generate do
  desc "Generate a new day scaffold"
  task :new_day, [:year_number, :day_number] do |_t, args|
    context = Tasks::Helpers.extract_year_and_day(**args)
    year_number = context.fetch(:year_number)
    day_number = context.fetch(:day_number)
    base_dir = "lib/advent_of_code_rb/y_#{year_number}/d_#{day_number}"

    Tasks::Helpers.setup_git(**context)
    Tasks::Helpers.ensure_files_exist(**context)
    Tasks::Helpers.append_modules(**context)
    # Generate files
    Tasks::Helpers.create_file(
      "#{base_dir}/solution.rb",
      Tasks::Helpers.render_template("tasks/generate/templates/solution.rb.erb", context)
    )
    Tasks::Helpers.create_file(
      "test/advent_of_code_rb/y_#{year_number}/d_#{day_number}/solution_test.rb",
      Tasks::Helpers.render_template("tasks/generate/templates/solution_test.rb.erb", context)
    )
    Tasks::Helpers.create_file(
      "#{base_dir}/input.txt",
      Tasks::Helpers.render_template("tasks/generate/templates/input.txt.erb", context)
    )

    puts "Scaffold for Day #{day_number} created successfully!"
    `bundle exec rubocop --autocorrect-all`
    puts "linting complete"
  end
end
