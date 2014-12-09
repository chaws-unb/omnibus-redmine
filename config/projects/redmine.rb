#
# Copyright 2014 YOUR NAME
#
# All Rights Reserved.
#

name "redmine"
maintainer "CHANGE ME"
homepage "https://CHANGE-ME.com"

# Defaults to C:/redmine on Windows
# and /opt/redmine on all other platforms
install_dir "#{default_root}/#{name}"

build_version Omnibus::BuildVersion.semver
build_iteration 1

# Creates required build directories
dependency "preparation"

# redmine dependencies/components
# dependency "somedep"

# Version manifest file
dependency "version-manifest"

exclude "**/.git"
exclude "**/bundler/git"
