require 'thor'
require 'pivotal-brancher/app'

module PivotalBrancher
  class Cli < Thor
    include Thor::Actions

    default_task :start

    no_commands do
      def story_branch_name(story, ids=nil)
        ids ||= [story.id]
        name = story.name.split(/[:-]\s*/, 2).last.gsub(/'/, '')
        (name.split(/[^\w]+/).map(&:downcase) + ids).join("_")
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
      end

      branch_name =
        case stories.length
        when 0
          say "No started stories found - could be you haven't started any stories yet?"
          exit
        when 1
          story = stories.first
          say "Switching to branch for:"
          say "#{story.id}: #{story.name}"
          story_branch_name(story)
        when (2..4)
          say "There are #{stories.length} stories started"
          stories.each do |story|
            say "  #{story.id}: #{story.name}"
          end
          say
          branchname = story_branch_name(stories.first, stories.map(&:id))
          unless yes?("Start branch named #{branchname}?")
            exit 1
          end
          branchname
        else
          say "You have #{stories.length} stories started - save some for later"
          exit 1
        end


      git_command = "git checkout -b #{branch_name}"
      if options.pretend?
        say "Would run: #{git_command}"
      else
        run git_command
      end
    end
  end

  CLI = Cli
end
