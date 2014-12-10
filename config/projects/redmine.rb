#
# Copyright 2014 YOUR NAME
#
# All Rights Reserved.
#

name "redmine"
maintainer "Redmine.org"
homepage "http://www.redmine.org/"

# Defaults to C:/redmine on Windows
# and /opt/redmine on all other platforms
install_dir "#{default_root}/#{name}"

build_version Omnibus::BuildVersion.semver
build_iteration 1

override :ruby, version: '2.1.1'
override :rubygems, version: '2.2.1'

# Creates required build directories
dependency "preparation"

# Includes redmine descriptor
dependency "redmine-src"

# Version manifest file
dependency "version-manifest"

exclude "**/.git"
exclude "**/bundler/git"
