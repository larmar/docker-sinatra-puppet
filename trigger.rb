#!/usr/bin/env ruby
#

require 'sinatra'
require 'json'
require 'fileutils'

configure do

  # Set this to where you want to keep your environments
  ENVIRONMENT_BASEDIR = "/etc/puppet/environments"

  # The git_dir environment variable will override the --git-dir, so we remove
  # it to allow us to create new repositories cleanly.
  ENV.delete('GIT_DIR')

  # Ensure that we have the underlying directories, otherwise the later commands
  # may fail in somewhat cryptic manners.
  unless File.directory? ENVIRONMENT_BASEDIR
    puts %Q{#{ENVIRONMENT_BASEDIR} does not exist, cannot create environment directories.}
    exit 1
  end

end

post '/trigger-puppet.json' do
  
  request_payload = JSON.parse request.body.read
  branchname = request_payload['ref'].sub(%r{^refs/heads/(.*$)}) { $1 }
  if branchname =~ /[\W-]/
    puts %Q{Branch "#{branchname}" contains non-word characters, ignoring it.}
    next
  end
  
  if branchname.eql? "production"
    puts %Q{Branch "#{branchname}" in not allowd as branch, ignoring it.}
    next
  end

  environment_path = "#{ENVIRONMENT_BASEDIR}/#{branchname}"
 
  source_repository = request_payload['repository']['url']

  after = request_payload['after']

  if after =~ /^0+$/
    # We've received a push with a null revision, something like 000000000000,
    # which means that we should delete the given branch.
    puts "Deleting existing environment #{branchname}"
    if File.directory? environment_path
      FileUtils.rm_rf environment_path, :secure => true
    end
  else
    # We have been given a branch that needs to be created or updated. If the
    # environment exists, update it. Else, create it.
    
    if File.directory? environment_path
      # Update an existing environment. We do a fetch and then reset in the
      # case that someone did a force push to a branch.
    
      puts "Updating existing environment #{branchname}"
      Dir.chdir environment_path
      %x{git fetch --all}
      %x{git reset --hard "origin/#{branchname}"}
    else
      # Instantiate a new environment from the current repository.
      
      Dir.chdir ENVIRONMENT_BASEDIR
      puts "Creating new environment #{branchname}"
      %x{git clone #{source_repository} #{environment_path} --branch #{branchname}}
    end
  end
end
