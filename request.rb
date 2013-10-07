class Request
  PATH_RE = /GET\s+((\/\w*)+)\sHTTP/ 
  attr_reader :path
  # initialize request object takes socket connection from client
  def initialize(connection)
    # puts "Connection object: #{connection}"
    @connection = connection
    line = @connection.gets
    # puts line
    @path = line.match(PATH_RE).nil? ? '' : line.match(PATH_RE)[1]
    # puts "Client requesting #{@path}"
    while line != "\r\n"
      # puts line
      line = @connection.gets
    end
  end
end
