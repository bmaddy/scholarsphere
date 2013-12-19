namespace :scholarsphere do
  if Rails.env.test?
    # Don't load these files in production
    require 'rspec/core/rake_task'
    require 'cucumber/rake/task'

    desc "Run specs"
    RSpec::Core::RakeTask.new(:rspec) do |t|
      t.rspec_opts = ['--color', '--backtrace', '--profile 20', '--format Fuubar']
    end

    desc "Execute Continuous Integration build (docs, tests with coverage)"
    task :ci => :environment do
      Rake::Task["jetty:config"].invoke
      Rake::Task["db:migrate"].invoke
      Rake::Task["scholarsphere:fits_conf"].invoke
      Rake::Task["scholarsphere:generate_secret"].invoke

      require 'jettywrapper'
      jetty_params = Jettywrapper.load_config.merge({:jetty_home => File.expand_path(File.join(Rails.root, 'jetty'))})

      error = nil
      error = Jettywrapper.wrap(jetty_params) do
        Rake::Task['scholarsphere:rspec'].invoke
        Cucumber::Rake::Task.new(:features) do |t|
          t.cucumber_opts = "--format pretty"
        end
      end
      raise "test failures: #{error}" if error
    end
  end
end
