# coding: utf-8

module GitDrive
  module Base
    def self.included(klass)
      klass.class_eval do
        extend Config
        extend ClassMethods
      end
    end

    module Config
      attr_accessor :set_git_bin_path, :set_git_repositories_root
      def git_config_with(&block)
        # cattr_accessor :set_git_bin_path
        yield self if block_given?
      end
    end
  end
end

ActiveRecord::Base.send :include, GitDrive::Base