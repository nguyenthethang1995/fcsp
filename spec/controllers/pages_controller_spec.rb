require "rails_helper"

RSpec.describe PagesController, type: :controller do
  describe "#index" do
    let(:user){FactoryBot.create :user}

    context "user has already signed in" do
      before do
        sign_in user
        get :index
      end

      it "return a 302 response" do
        expect(response).to have_http_status "302"
      end

      it "redirect to user page" do
        expect(response).to redirect_to user_path user
      end
    end

    context "user has not signed in yet" do
      before do
        get :index
      end

      it "responds successfully" do
        expect(response).to be_success
      end

      it "returns a 200 response" do
        expect(response).to have_http_status  "200"
      end
    end
  end
end
