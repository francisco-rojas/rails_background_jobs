$redis = Redis.new(host: 'localhost', port: 6379)
Resque.redis = $redis