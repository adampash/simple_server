require 'socket'

class Server
  PORT = 2000
  HOST = '127.0.0.1'
  MESSAGE = "Hello world"
  PATH_RE = /GET\s+((\/\w*)+)\sHTTP/ 
  DIR     = File.expand_path(File.join(File.dirname(__FILE__)))
  DEFAULT = "#{DIR}/public/index.html"
  FOUR_OH_FOUR = "#{DIR}/public/404.html"
 

  def self.start
    @socket = Socket.new(:INET, :STREAM) # TCP socket
    addr = Socket.pack_sockaddr_in(PORT, HOST)
    @socket.bind(addr)
    @socket.listen(2)
    loop do
      client, addr_info = @socket.accept

      line = client.gets
      path = line.match(PATH_RE).nil? ? '' : line.match(PATH_RE)[1]
      # puts "Client requesting #{path}"
      while line != "\r\n"
        # puts line
        line = client.gets
      end
      # puts "End of request header"
      begin
        message = read_file("#{DIR}/public#{path}/index.html")
      rescue 
        message = read_file(FOUR_OH_FOUR)
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
    # @socket.shutdown
    @socket.close
  end

  def self.read_file(file_path)
    message = ''
    File.open(file_path).each_line do |line|
      # puts line
        message += line
    end
    message
  end
    

end
