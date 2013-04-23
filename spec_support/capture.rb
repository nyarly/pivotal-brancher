require 'stringio'

RSpec.configure do |config|
  def capture_stdout
    begin
      old_stream = $stdout
      new_stream = StringIO.new
      $stdout = new_stream
      yield
      result = $stdout.string
    ensure
      $stdout = old_stream
    end

    result
  end
end
