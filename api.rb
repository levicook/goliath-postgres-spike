# api.rb

require './boot'

class Api < Goliath::API

  def response(env)
    pg_result = connection_pool do |connection|
      sync(connection.execute('select pg_sleep(1)'))
    end

    [ 200, { 'Content-Type' => 'text/plain' }, pg_result.fields ]
  end

  private

  def connection_pool
    config['postgres-connection-pool'].execute(false) { |c| yield c }
  end

  def sync(df)
    EM::Synchrony.sync(df)
  end

end
