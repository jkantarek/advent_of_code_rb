# frozen_string_literal: true

require "erb"
require "fileutils"

module Tasks
  class Helpers
    class << self
      def extract_year_and_day(year_number: Time.now.year, day_number: nil)
        last_day = Dir.glob("lib/advent_of_code_rb/y_#{year_number}/*")
                      .map { |days| days.split("/d_").last.to_i }
                      .max
        next_day_number = (last_day || 0) + 1
        day_num = day_number || next_day_number

        {
          year_number: year_number,
          day_number: Integer(day_num).to_s.rjust(2, "0")
        }
      end

      def setup_git(year_number:, day_number:)
        `git pull --rebase --autostash`
        `git checkout -b "y_#{year_number}/d_#{day_number}"`
      end

      def ensure_files_exist(year_number:, day_number:)
        test_path = "test/advent_of_code_rb/y_#{year_number}/d_#{day_number}"
        lib_path = "lib/advent_of_code_rb/y_#{year_number}/d_#{day_number}"
        [test_path, lib_path].each do |path|
          FileUtils.mkpath(path)
        end
      end

      def append_modules(year_number:, day_number:)
        File.open("lib/advent_of_code_rb.rb", "r+") do |file|
          next if file.read.match?("module AdventOfCodeRb::Y#{year_number}; end")

          file.puts("\nmodule AdventOfCodeRb::Y2024; end")
        end

        FileUtils.touch("lib/advent_of_code_rb/y_#{year_number}/y_#{year_number}.rb")

        File.open("lib/advent_of_code_rb/y_#{year_number}/y_#{year_number}.rb", "r+") do |file|
          next if file.read.match?("module AdventOfCodeRb::Y#{year_number}::D#{day_number}; end")

          file.puts("\nmodule AdventOfCodeRb::Y#{year_number}::D#{day_number}; end")
        end
      end

      def render_template(template_path, context)
        template = File.read(template_path)
        ERB.new(template).result_with_hash(context)
      end

      def create_file(path, content)
        FileUtils.mkpath(File.dirname(path))
        File.write(path, content)
      end
    end
  end
end
