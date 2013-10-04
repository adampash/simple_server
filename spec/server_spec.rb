require './server.rb'
require 'open-uri'
describe "Server" do
  Thread.new {
    begin
      Server.start
      # sleep(1)
    ensure
      Server.close
    end
  }
  it "should return something when connected to" do
    response = open('http://localhost:2000/').read
    expect(response).to include("Hello, world!")
  end

  it "should return the FOO page when requested" do
    response = open('http://localhost:2000/foo/bar').read
    expect(response).to include("Hello, FOO!")
  end
  it "should return the 404 page when requested" do
    response = open('http://localhost:2000/nothing_exists/here').read
    expect(response).to include("404")
  end
  
end
