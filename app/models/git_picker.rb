class GitPicker < GitDrive::Picker
  git_config_with do |c|
    c.set_git_bin_path = '/usr/bin/git'
    c.set_git_repositories_root = "/home/for_ssh/repositories"
  end
end
