# config/postgres-connection-pool.rb

pg_environment = String(Goliath.env)
pg_config_file = File.expand_path('../config/postgres.yml', __FILE__)
pg_config_yaml = YAML.load_file(pg_config_file)

pg_config = pg_config_yaml[pg_environment]
pg_config.symbolize_keys!

pool_size = pg_config.delete(:pool)

config['postgres-connection-pool'] = EM::Synchrony::ConnectionPool.new(size: pool_size) do
  EM::Postgres.new(pg_config)
end
