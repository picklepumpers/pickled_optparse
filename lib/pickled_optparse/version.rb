# Contains any pickled_optparse specific settings
module PickledOptparse
  # The current version of the software
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 1
    BUILD = nil

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end