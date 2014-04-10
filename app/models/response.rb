class Response
  attr_accessor :count, :offers, :response

  def initialize(json)
    self.response = JSON.parse(json) 
    self.count = @response["count"].to_i
    self.offers = @response["offers"]
  end
end
