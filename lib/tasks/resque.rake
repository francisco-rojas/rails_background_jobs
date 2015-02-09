require "resque/tasks"
require 'resque/scheduler/tasks'

namespace :resque do
  task :setup  => :environment do
    require 'resque'

    Resque.before_fork do
      defined?(ActiveRecord::Base) and
          ActiveRecord::Base.connection.disconnect!
    end

    Resque.after_fork do
      defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
    end
  end

  task :setup_schedule => :setup do
    require 'resque-scheduler'

    Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")
    Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }

  end

  task :scheduler_setup => :setup_schedule
end
