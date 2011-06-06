#!/usr/bin/env ruby
# -*- ruby -*-

require 'fileutils'

SRC_DIR      = 'src'
MISSION_DIR  = 'missions'

SRC_FILES = FileList["#{SRC_DIR}/*"]
MISSION_FILES = SRC_FILES.pathmap("#{MISSION_DIR}/%f")

module Missions
  # Remove solution info from source
  #   __(a,b)     => __
  def Missions.remove_solution(line)
    line = line.gsub(/\b__\([^\)]+\)/, "__")
    line
  end

  def Missions.make_mission_file(infile, outfile)
    if infile =~ /lib/
      FileUtils::cp_r infile, outfile
    else
      open(infile) do |ins|
        open(outfile, "w") do |outs|
          state = :copy
          ins.each do |line|
            state = :skip if line =~ /^ *-- begin skip/
            case state
            when :copy
              outs.puts remove_solution(line)
            else
              # do nothing
            end
            state = :copy if line =~ /^ *-- end skip/
          end
        end
      end
    end
  end
end

task :default => 'missions:run'

namespace :missions do

  desc "Trying to execute the missions"
  task :run do
    cd 'missions'
    sh 'lua missions.lua'
  end

  desc "Execute the solved missions"
  task :run_src do
    cd 'src'
    sh 'lua missions.lua'
  end

  desc "Generate the Missions from the source files from scratch."
  task :regen => ['missions:delete', 'missions:gen']

  desc "Generate the Missions from the changed source files."
  task :gen => MISSION_FILES

  desc "Delete the generated mission files"
  task :delete do
    rm_rf MISSION_DIR
  end

end

directory MISSION_DIR

SRC_FILES.each do |mission_src|
  file mission_src.pathmap("#{MISSION_DIR}/%f") => [MISSION_DIR, mission_src] do |t|
    Missions.make_mission_file mission_src, t.name
  end
end

namespace :git do

  def commit_message
    return ENV['m'] if ENV['m']
    raise "Commit message expected. Sample:\n   rake git:commit m='your commit message'"
  end

  desc "regenerate missions & push to the git repository"
  task :release => ['missions:regen', 'git:add', 'git:commit', 'git:push']

  desc "add all the modifications to the git repository, including deletions"
  task :add do
    sh 'git add .'
    sh 'git ls-files -z -d | xargs -0 --no-run-if-empty git rm'
  end

  desc "Commit with a message"
  task :commit do
    sh "git commit -m #{commit_message.inspect}"
  end

  desc "Push to origin"
  task :push do
    sh "git push origin master"
  end

end

