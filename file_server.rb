module FileServer


  def self.serve(root, path)
    puts "Inside file server"
    begin
      message = read_file("#{root}/public#{path}/index.html")
      status = 200
    rescue 
      four_oh_four = "#{root}/public/404.html"
      message = read_file(four_oh_four)
      status = 404
    end
    message    
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
