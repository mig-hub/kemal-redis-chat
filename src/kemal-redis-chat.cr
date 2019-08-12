require "kemal"
require "kilt/slang"
require "redis"

CHANNEL = "chat"
SOCKETS = [] of HTTP::WebSocket

REDIS = Redis.new
spawn do
  redis_sub = Redis.new
  redis_sub.subscribe(CHANNEL) do |on|
    on.message do |channel, message|
      SOCKETS.each {|ws| ws.send(message) }
    end
  end
end

get "/" do
  render "views/index.slang"
end

ws "/chat" do |socket|

  SOCKETS << socket

  socket.on_message do |message|
    REDIS.publish(CHANNEL, message)
  end

  socket.on_close do
    SOCKETS.delete socket
  end

end

Kemal.config.port = ENV["PORT"].to_i || 3000
Kemal.run

