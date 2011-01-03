# coding: utf-8

module GitDrive  # Generic GitApi error exception class.
  class GitDriveError < StandardError
  end

  # Raised GitDrive params error exception when the need params lose {:user}
  class GitDriveParamsError < GitDriveError
  end

  # Raised GitDrive command params error exception when the :action params not in ACTIONS_METHODS list
  class GitDriveCommandParamsError < GitDriveParamsError
  end

  # Raised GitDriveCmdExecute command params error exception when the shell command is valid
  class GitDriveCmdExecuteError < GitDriveError
  end
end