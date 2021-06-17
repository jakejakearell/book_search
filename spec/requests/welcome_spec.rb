require 'rails_helper'

describe "Welcome Page" do
  describe 'Happy Paths' do
    it "will send an message telling users to go to READ-ME for endpoints" do
      get '/'
      expect(response).to be_successful
      expect(response).to be_successful
      welcome = JSON.parse(response.body, symbolize_names: true)
      expect(welcome).to be_a(Hash)
      expect(welcome).to have_key(:endpoints)
      expect(welcome[:endpoints]).to be_a(String)
    end
  end
end
