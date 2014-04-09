require 'spec_helper'

describe Api::SpPay do

  describe "#get_data" do
    subject { described_class.new }

    context "Response status is 400" do
      before do
        stub_request(:get, /api.sponsorpay.com\/feed\/v1\/offers.json/).
          to_return(status: 400, body: '{"test" : "test"}', headers: {})
      end
      it "returns nil" do 
        expect(subject.get_data).to be_nil
      end
    end

    before do
      stub_request(:get, /api.sponsorpay.com\/feed\/v1\/offers.json/).
        to_return(status: 200, body: '{"test" : "test"}', headers: {})
      Api::SpPay.any_instance.stub(:check_signature).and_return(true)
    end

    context "Sygnature is incorrect" do
      before { Api::SpPay.any_instance.stub(:check_signature).and_return(false) }
      it "returns nil" do 
        expect(subject.get_data).to be_nil
      end
    end

    context "Response status is 200" do
      it "returns json" do
        expect(subject.get_data).to eq({"test"=>"test"})
      end
    end    

  end
end
