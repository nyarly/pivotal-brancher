require 'valise'
require 'pivotal-tracker'

module PivotalBrancher

  class App
    def initialize
      @files = Valise::define do
        rw ".pivotal-brancher"
        rw "~/.pivotal-brancher"

        handle "*.yaml", :yaml, :hash_merge
      end
      configure_pivotal
    end

    def configs
      @files.find("config.yaml").contents
    end

    def configure_pivotal
      PivotalTracker::Client.token = configs["token"]
      PivotalTracker::Client.use_ssl
      #RestClient.log = "stdout"
    end

    def project
      @project = PivotalTracker::Project.find(configs["project"])
    end

    def started_stories
      project.stories.all(:current_state => "started", :owned_by => configs["user"])
    end
  end
end
