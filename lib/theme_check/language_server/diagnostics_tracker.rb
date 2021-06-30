# frozen_string_literal: true
require "logger"

module ThemeCheck
  module LanguageServer
    class DiagnosticsTracker
      def initialize
        @previously_reported_files = Set.new
        @single_files_offenses = {}
        @first_run = true
      end

      def first_run?
        @first_run
      end

      def build_diagnostics(offenses, analyzed_files: nil)
        reported_files = Set.new
        new_single_file_offenses = {}
        analyzed_files = analyzed_files.map { |path| Pathname.new(path) } if analyzed_files

        offenses.group_by(&:template).each do |template, template_offenses|
          next unless template
          reported_offenses = template_offenses
          previous_offenses = @single_files_offenses[template.path]
          if analyzed_files.nil? || analyzed_files.include?(template.path)
            # We re-analyzed the file, so we know the template_offenses are update to date.
            reported_single_file_offenses = reported_offenses.select(&:single_file?)
            if reported_single_file_offenses.any?
              new_single_file_offenses[template.path] = reported_single_file_offenses
            end
          elsif previous_offenses
            # Merge in the previous ones, if some
            reported_offenses |= previous_offenses
          end
          yield template.path, reported_offenses
          reported_files << template.path
        end

        @single_files_offenses.each do |path, _|
          # Already reported above, skip
          next if reported_files.include?(path)

          if analyzed_files.nil? || analyzed_files.include?(path)
            # We re-analyzed this file, if it was not reported, all offenses in it got fixed
            yield path, []
            new_single_file_offenses[path] = nil
          end
          # NOTE: No need to re-report previous offenses as LSP should keep them around until
          # we clear them.
          reported_files << path
        end

        # Publish diagnostics with empty array if all issues on a previously reported template
        # have been fixed.
        (@previously_reported_files - reported_files).each do |path|
          yield path, []
        end

        @previously_reported_files = reported_files
        @single_files_offenses.merge!(new_single_file_offenses)
        @first_run = false
      end
    end
  end
end
