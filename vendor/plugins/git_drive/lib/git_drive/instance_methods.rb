# coding: utf-8

module GitDrive
  module Base
    # any method placed here will apply to instaces
    module InstanceMethods
      def squawk(string)
        write_attribute(self.class.set_git_bin_path, string.to_squawk)
      end
    end
  end
end