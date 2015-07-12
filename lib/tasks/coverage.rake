namespace :spec do

  desc 'Create rspec coverage for cruisecontrol.rb'
  task :cruise_coverage => :coverage do
    out = ENV['CC_BUILD_ARTIFACTS']
    mkdir_p out unless File.directory? out if out
    mv 'coverage', "#{out}/coverage" if out
  end

  desc 'Create rspec coverage'
  task :coverage do
    ENV['COVERAGE'] = 'true'
    Rake::Task['spec'].execute
  end

end