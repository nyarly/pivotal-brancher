require 'pivotal-brancher'
require 'ostruct'

describe PivotalBrancher::Cli do
  before :all do
    described_class.instance_eval do
      @no_commands = true
    end
  end

  let :cli do
    described_class.new.tap do |cli|
      cli.app = brancher_app
      cli.stub(:run)
    end
  end

  describe "with started stories" do
    let :brancher_app do
      PivotalBrancher::App.new.tap do |app|
        app.stub(:started_stories).and_return(stories)
      end
    end

    let :stories do
      [
        OpenStruct.new(:id => "123456", :name => "This: is a story")
      ]
    end

    it "should report on stories considered" do
      expect(capture_stdout do
        cli.start
      end).to match(/is a story/)
    end

    it "should build branch names" do
      expect(cli.story_branch_name(stories.first)).to eql("123456_this_is_a_story")
    end

    it "should execute git checkout -b" do
      cli.should_receive(:run).with("git checkout -b 123456_this_is_a_story")
      capture_stdout do
        cli.start
      end
    end
  end

  describe "with no started stories" do
    let :brancher_app do
      PivotalBrancher::App.new.tap do |app|
        app.stub(:started_stories).and_return([])
      end
    end

    it "should not execute git" do
      cli.should_not_receive(:run)
      capture_stdout do
        expect do
          cli.start
        end.to raise_error(SystemExit)
      end
    end
  end
end
