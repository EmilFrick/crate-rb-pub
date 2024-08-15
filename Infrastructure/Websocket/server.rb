require 'em-websocket'
require 'json'

module WebsocketService
  def get_message
    msg = ApplicationDbContext.instance.get_all_as_json("mining")
    puts msg
  end
  
  def self.run_websocket(messenger = nil)
    Thread.new do
      EM.run {
        @clients = []
        
        EM::WebSocket.run(host: '0.0.0.0', port: 3000) do |ws|
          ws.onopen { p @clients << ws }
          ws.onmessage { |msg| @clients.each { |client| client.send msg } }
          ws.onclose { @clients.delete(ws) }
        end

        # Sending a message to all connected clients
        EM.add_periodic_timer(5) do
          puts ApplicationDbContext.instance.get_all_as_json("mining")
          
          puts "Currently connected clients:"
          @clients.each { |client| puts client.object_id }

          @clients.each { |client| client.send "Hello, World!" } if @clients.count > 0
        end
      }
    end
  end
end
