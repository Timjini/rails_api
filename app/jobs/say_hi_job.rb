class SayHiJob < ApplicationJob
  
  def perform
    puts "Hello ==============="
  end
end