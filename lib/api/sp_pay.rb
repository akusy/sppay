class Api::SpPay

  def initialize uid=ENV['UID'], pub0=nil, page=1
    self.host = "api.sponsorpay.com"
    self.api_key = ENV['SP_API']

    #params in alphabetical order
    self.appid = 157
    self.device_id = ENV['DEVICE_ID']
    self.format = "json"
    self.ip = ENV['SP_IP']
    self.locale = "de"
    self.offer_types = 112
    self.page = page
    self.pub0 = escape_params(pub0)
    self.uid = escape_params(uid)
  end

  def get_data
    begin
      response = Net::HTTP.get_response(@host, get_query)
    rescue => e
      Rails.logger.error "SpPay request error: #{e}"
      return nil
    end
    valid_params?(response) ? JSON.parse(response.body) : nil
  end

  private

  attr_accessor :host, :api_key, :device_id, :format, :locale, :appid, :ip, 
                :offer_types, :uid, :pub0, :page

  def get_query
    "/feed/v1/offers.json?#{get_params}&hashkey=#{calculate_hash}"
  end

  def get_params
    "appid=#{@appid}&device_id=#{@device_id}&format=#{@format}&ip=#{@ip}"\
    "&locale=#{@locale}&offer_types=#{@offer_types}&page=#{@page}&pub0=#{@pub0}"\
    "&timestamp=#{Time.new.to_i}&uid=#{@uid}"
  end

  def calculate_hash
    Digest::SHA1.hexdigest "#{get_params}&#{@api_key}"
  end

  def valid_params? response
    response.code == "200" && check_signature(response)
  end

  def check_signature response
    signature = response.get_fields('X-Sponsorpay-Response-Signature').try(:first)
    if signature == Digest::SHA1.hexdigest("#{response.body}#{@api_key}")
      true
    else
      Rails.logger.error "SpPay request error: incorrect signature: #{signature}"
      false
    end
  end

  def escape_params param
    Rack::Utils.escape param
  end
end
