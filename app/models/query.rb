class Query < ActiveRecord::Base
  validates :uid, :pub0, presence: true
  validates :page, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  after_save :get_response

  private

  def get_response
    if response = Api::SpPay.new(uid, pub0, page).get_data
      write_to_cache(id, Response.new(response))
    end
  end

  def write_to_cache key, value
    Rails.cache.write(key, value, namespace: :sppay, expires_in: 1.hour)
  end
end
