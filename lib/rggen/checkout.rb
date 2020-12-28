# frozen_string_literal: true

require 'yaml'

module RgGen
  module Checkout
    class << self
      def add_to_gemfile(gemfile, root)
        load_list(root).each_key do |rggen_library|
          library_path = File.join(root, rggen_library)
          spec_path = File.join(library_path, "#{rggen_library}.gemspec")
          File.exist?(spec_path) && gemfile.instance_eval do
            gem rggen_library, path: library_path
          end
        end
      end

      private

      def repository_root
        `git rev-parse --show-toplevel`.chomp
      end

      def repository_name
        ENV['RGGEN_REPOSITORY_NAME'] || File.basename(repository_root)
      end

      def branch_name
        ENV['RGGEN_BRANCH_NAME'] || `git branch --show-current`.chomp
      end

      def load_list(root)
        list = find_list(root)
        YAML.load_file(list)
      end

      def find_list(root)
        repository = repository_name
        [branch_name, 'master']
          .map { |branch| list_path(root, repository, branch) }
          .find(&File.method(:exist?))
      end

      def list_path(root, repository, branch)
        File.join(root, 'rggen-checkout', repository, "#{branch}.yml")
      end
    end
  end
end
