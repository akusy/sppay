class ResponseDecorator < Draper::Decorator
  delegate_all

  def offers
    if object.count > 0
      h.render "queries/offers", offers: object.offers
    else
      h.render "queries/no_offers"
    end
  end
  
end
