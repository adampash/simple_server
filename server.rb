require 'socket'

class Server
  PORT = 2000
  HOST = '127.0.0.1'
  MESSAGE = "Hello world"
  PATH_RE = /GET\s+((\/\w*)+)\sHTTP/ 
  DIR     = File.expand_path(File.join(File.dirname(__FILE__)))

  def self.start
    @socket = Socket.new(:INET, :STREAM) # TCP socket
    addr = Socket.pack_sockaddr_in(PORT, HOST)
    @socket.bind(addr)
    @socket.listen(2)
    loop do
      client, addr_info = @socket.accept

      line = client.gets
      path = line.match(PATH_RE).nil? ? '' : line.match(PATH_RE)[1]
      puts "Client requesting #{path}"
      while line != "\r\n"
        puts line
        line = client.gets
      end
      puts "End of request header"
      message = ''
      begin
        File.open("#{DIR}/public#{path}/index.html").each_line do |line|
          puts line
          message += line
        end
      rescue 
        message = MESSAGE
      end
      client.puts "HTTP/1.1 200 OK\n"
      client.puts "Content-Type: text/html; charset=UTF-8"
      client.puts "Content-Length: #{message.length}"
      client.puts "\n"
      client.puts message
      client.close
    end
  end

  def self.close
    @socket.shutdown
    @socket.close
  end

end
