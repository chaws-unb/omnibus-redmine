#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
# Copyright:: Copyright (c) 2014 GitLab.com
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "redmine-src"
default_version "master"

dependency "ruby"
dependency "rubygems"
dependency "bundler"
dependency "postgresql"

source :git => "https://github.com/chaws-unb/redmine.git"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
}

build do

  # Create necessary directories
  command "mkdir -p #{install_dir}/embedded/data"

  # Create the database
  command "#{install_dir}/embedded/bin/initdb -D #{install_dir}/embedded/data -U postgres"

  # Initiate the database
  command "#{install_dir}/embedded/bin/postgres -D #{install_dir}/embedded/data -p 5433 &"

  # Waits until service starts
  command "sleep 3"

  # Create redmine role and database
  command "#{install_dir}/embedded/bin/psql -U postgres -p 5433 -c \"CREATE ROLE redmine LOGIN ENCRYPTED PASSWORD 'redmine' NOINHERIT VALID UNTIL 'infinity';\""
  command "#{install_dir}/embedded/bin/psql -U postgres -p 5433 -c \"CREATE DATABASE redmine OWNER=redmine;\""

  # Copying database configuration file
  block do
    open("config/database.yml", "w") do |file|
      file.print <<-EOH
production:
  adapter: postgresql
  database: redmine
  host: localhost
  username: redmine
  password: "redmine"
       EOH
    end
  end

  # Install all the gems
  bundle_without = %w{development test rmagick}
  bundle "install --without #{bundle_without.join(" ")} --path=#{install_dir}/embedded/service/gem", :env => env

  # Generate token
  rake "generate_secret_token"
end
