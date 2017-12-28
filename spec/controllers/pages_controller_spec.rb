require "rails_helper"

RSpec.describe PagesController, type: :controller do
  describe "GET #index" do
    before do
      get :index
    end

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to be_success
    end
  end
end
