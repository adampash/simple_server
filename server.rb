require 'socket'
require './request.rb'
require './file_server.rb'

module Server
  PORT = 2000
  HOST = '127.0.0.1'
  MESSAGE = "Hello world"
  DIR     = File.expand_path(File.join(File.dirname(__FILE__)))
  DEFAULT = "#{DIR}/public/index.html"
 

  def self.start
    @socket = Socket.new(:INET, :STREAM) # TCP socket
    addr = Socket.pack_sockaddr_in(PORT, HOST)
    @socket.bind(addr)
    @socket.listen(2)
    loop do
      client, addr_info = @socket.accept
      request = Request.new(client)
      # puts "End of request header"
      # puts request.path
      message = FileServer.serve(DIR, request.path)
      client.puts "HTTP/1.1 200 OK\n"
      client.puts "Content-Type: text/html; charset=UTF-8"
      client.puts "Content-Length: #{message.length}"
      client.puts "\n"
      client.puts message
      client.close
    end
  end

  def self.close
    # @socket.shutdown
    @socket.close
  end

    

end
