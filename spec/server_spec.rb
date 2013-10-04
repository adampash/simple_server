require './server.rb'
require 'open-uri'
describe "Server" do
  Thread.new {
    Server.start
    sleep(1)
    Server.close
  }
  it "should return something when connected to" do
    response = open('http://localhost:2000/foo/bar').read
    puts response
    expect(response).to eq("Hello world")
  end
end
