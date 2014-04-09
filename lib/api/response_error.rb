class Api::ResponseError < StandardError
  def initialize(msg = "Incorrect signature")
    super(msg)
  end
end