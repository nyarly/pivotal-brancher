require 'thor'
require 'pivotal-brancher/app'

module PivotalBrancher
  class Cli < Thor
    include Thor::Actions

    default_task :start

    no_commands do
      def story_branch_name(story)
        ([story.id] + story.name.split(/[^\w]+/).map(&:downcase)).join("_")
      end

      def app=(app)
        @app = app
      end

      def app
        @app ||= PivotalBrancher::App.new
      end
    end

    desc "start", "Start a branch for your first started Pivotal story"
    method_options %w{pretend -p} => :boolean #ok
    def start
      stories = app.started_stories
      if stories.empty?
        say "No started stories found - could be you haven't started any stories yet?"
        exit
      end
      story = stories.shift

      #Need to handle empty case ( you should probably start a story...)
      #

      say "Switching to branch for:"
      say "#{story.id}: #{story.name}"
      say ""
      say "Other started stories are:"
      stories.each do |story|
        say "#{story.id}: #{story.name}"
      end
      git_command = "git checkout -b #{story_branch_name(story)}"
      if options.pretend?
        say "Would run: #{git_command}"
      else
        run git_command
      end
    end
  end

  CLI = Cli
end
