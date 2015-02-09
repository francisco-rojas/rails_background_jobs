rails_env = ENV['RAILS_ENV'] || "development"
rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/..'
num_workers = rails_env == 'production' ? 5 : 2

num_workers.times do |num|
  God.watch do |w|
    pid_file = "#{rails_root}/tmp/pids/resque-#{num}.pid"
    w.dir = "#{rails_root}"
    w.name = "resque-#{num}"
    w.interval = 30.seconds
    w.group = 'resque'
    w.env = {"QUEUE"=>"critical,high,low", "RAILS_ENV"=>rails_env, "PIDFILE"=>pid_file}
    w.start = "bundle exec rake environment resque:work"
    w.log = "#{rails_root}/log/resque.log"
    w.err_log = "#{rails_root}/log/resque_error.log"
    w.pid_file = pid_file
    # when running as a non-root user, don't specify w.uid = or w.gid =
    # w.uid = 'deploy'
    # w.gid = 'deploy'

    # restart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 350.megabytes
        c.times = 2
      end
    end

    # determine the state on startup
    w.transition(:init, { true => :up, false => :start }) do |on|
      on.condition(:process_running) do |c|
        c.running = true
      end
    end

    # determine when process has finished starting
    w.transition([:start, :restart], :up) do |on|
      on.condition(:process_running) do |c|
        c.running = true
        c.interval = 5.seconds
      end

      # failsafe
      on.condition(:tries) do |c|
        c.times = 5
        c.transition = :start
        c.interval = 5.seconds
      end
    end

    # start if process is not running
    w.transition(:up, :start) do |on|
      on.condition(:process_running) do |c|
        c.running = false
      end
    end
  end
end