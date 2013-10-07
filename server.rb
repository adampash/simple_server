require 'socket'
require './request.rb'
require './file_server.rb'

module Server
  HOST = '127.0.0.1'
  PORT = 2000
  DIR     = File.expand_path(File.join(File.dirname(__FILE__)))

  def self.start
    # puts "Server running at #{HOST}:#{PORT}"
    @socket = Socket.new(:INET, :STREAM) # TCP socket
    addr = Socket.pack_sockaddr_in(PORT, HOST)
    @socket.bind(addr)
    @socket.listen(2)
    loop do
      connection, addr_info = @socket.accept
      request = Request.new(connection)
      # puts "End of request header"
      # puts request.path
      message = FileServer.read(DIR, request.path)
      connection.puts "HTTP/1.1 200 OK\n"
      connection.puts "Content-Type: text/html; charset=UTF-8"
      connection.puts "Content-Length: #{message.length}"
      connection.puts "\n"
      connection.puts message
      connection.close
    end
  end

  def self.close
    # @socket.shutdown
    @socket.close
  end

end
