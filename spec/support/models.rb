models = File.expand_path("spec/support/models/*.rb")
Dir[models].sort.each do |file|
  autoload file.gsub(/.*\/(.*)\..*/, '\1').camelize.to_sym, file
end

