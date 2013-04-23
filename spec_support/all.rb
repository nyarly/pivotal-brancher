support_dir = File::dirname(__FILE__)
Dir[File::expand_path("../**/*.rb", __FILE__)].each do |file|
  require file
end
