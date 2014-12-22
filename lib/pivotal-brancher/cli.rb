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
        when (2..6)
          say "There are #{stories.length} stories started"
          branchname = nil
          indexes = (1..stories.length).to_a
          loop do
            stories.each_with_index do |story, index|
              say "#{index+1}#{indexes.include?(index + 1) ? "*" : " "} #{story.id}: #{story.name}"
            end
            say
            chosen_stories = stories.each_with_index.find_all do |story, index|
              indexes.include? index + 1
            end.map{|story,_| story}
            branchname = story_branch_name(chosen_stories.first, chosen_stories.map(&:id))

            answer = ask("Start branch named #{branchname}? (or numbers to filter)")
            if /y|yes/ =~ answer
              break
            elsif /\d+(?:\s+\d+)*/ =~ answer
              indexes = answer.split(/\s+/).map(&:to_i)
            else
              exit 1
            end
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
