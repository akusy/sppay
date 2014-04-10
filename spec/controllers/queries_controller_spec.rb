require 'spec_helper'

describe QueriesController do

  describe "GET #index" do
    it "renders the :index view" do
      get :index
      expect(response.status).to eq 200
      expect(response).to render_template :index
    end
  end  

  describe "GET #show" do
    before do
      Rails.cache.clear
      stub_request(:get, /api.sponsorpay.com\/feed\/v1\/offers.json/).
        to_return(status: 200, body: '{"test" : "test"}', headers: {})
    end
    let(:query){ Fabricate(:query) } 

    context "Cache contains response" do
      it "assigns the @response" do 
        Rails.cache.write(query.id, "value", namespace: :sppay, expires_in: 1.hour)
        get :show, id: query.id

        assigns(:response).should eq("value")
        assigns(:response).should be_decorated_with ResponseDecorator
        expect(response.status).to eq 200
        expect(response).to render_template :show
      end
    end

    context "Cache expires or does not contain response" do
      it "assigns the @response" do 
        get :show, id: query.id

        expect(flash[:alert]).to eq "No valid response, try again"
        expect(response).to redirect_to root_path
      end
    end
  end 

  describe "POST #create" do 
    before do
      stub_request(:get, /api.sponsorpay.com\/feed\/v1\/offers.json/).
        to_return(status: 200, body: '{"test" : "test"}', headers: {})
    end

    context "With valid attributes" do 
      it "creates a new query" do 
        expect{ post :create, query: Fabricate.attributes_for(:query) }.to change(Query, :count).by(1) 
      end 

      it "redirects to the new query" do 
        post :create, query: Fabricate.attributes_for(:query)
        expect(response).to redirect_to Query.last 
      end
    end

    context "With invalid attributes" do 
      it "does not save a new query" do 
        expect{ post :create, query: { uid: nil, pub0: nil } }.to_not change(Query, :count)
      end 

      it "redirects to the root" do 
        post :create, query: { uid: nil, pub0: nil }
        expect(flash[:alert]).to eq "Uid can't be blank. Pub0 can't be blank"
        expect(response).to redirect_to root_path
      end
    end

  end
end