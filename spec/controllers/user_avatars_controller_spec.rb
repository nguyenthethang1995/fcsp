require "rails_helper"

RSpec.describe UserAvatarsController, type: :controller do
  let!(:user){FactoryBot.create :user}
  let!(:another_user){FactoryBot.create :user}

  before(:each, :sign_in_user) do
    sign_in user
  end

  before(:each, :sign_in_another_user) do
    sign_in another_user
  end

  before(:each, :picture_valid) do
    picture = Rack::Test::UploadedFile
      .new Rails.root.join("spec", "support", "education", "image", "test.jpg")
    post :create, params: {image: {picture: picture}}
  end

  before(:each, :picture_invalid) do
    picture = Rack::Test::UploadedFile
      .new Rails.root.join("spec", "support", "education", "image", "fail_test.txt")
    post :create, params: {image: {picture: picture}}
  end

  describe "#create" do
    context "params picture blank", :sign_in_user do
      before do
        post :create, params: {image: ""}
      end

      it "has flash danger" do
        expect(controller).to set_flash[:danger]
          .to I18n.t "user_avatars.you_didnt_choose"
      end

      it "redirect to edit page" do
        expect(response).to redirect_to edit_user_path user
      end
    end

    context "user not sign in", :picture_valid do
      it "redirect to home page" do
        expect(response).to redirect_to root_path
      end

      it "has flash danger" do
        expect(controller).to set_flash[:alert]
          .to I18n.t "devise.failure.unauthenticated"
      end
    end

    context "params picture valid", :sign_in_user, :picture_valid  do
      it "has flash success" do
        expect(controller).to set_flash[:success]
          .to I18n.t "user_avatars.create.success"
      end

      it "redirect to user page" do
        expect(response).to redirect_to user_path user
      end
    end

    context "params picture invalid", :sign_in_user, :picture_invalid do
      it "has flash danger" do
        expect(controller).to set_flash[:danger]
          .to I18n.t "user_avatars.create.fail"
      end
    end
  end

  describe "#update" do
    before do
      sign_in user
      picture_1 = Rack::Test::UploadedFile
        .new Rails.root.join("spec", "support", "education", "image", "test.jpg")
      picture_2 = Rack::Test::UploadedFile
        .new Rails.root.join("spec", "support", "education", "image", "default.png")
      post :create, params: {image: {picture: picture_1}}
      post :create, params: {image: {picture: picture_2}}
    end

    context "params blank" do
      before do
        patch :update, params: {image: {picture: ""}}
      end

      it "has flash danger" do
        expect(controller).to set_flash[:danger]
          .to I18n.t "user_avatars.you_didnt_choose"
      end

      it "has status 302" do
        expect(response).to have_http_status 302
      end

      it "redirect to edit page" do
        expect(response).to redirect_to edit_user_path user
      end
    end

    context "param valid" do
      before do
        patch :update, params: {image: {picture: user.images.first}}
      end

      it "has flash success" do
        expect(controller).to set_flash[:success]
          .to I18n.t "user_avatars.update.success"
      end

      it "redirect to user page" do
        expect(response).to redirect_to user_path user
      end
    end

    context "user not sign in" do
      before do
        sign_out user
        patch :update, params: {image: {picture: user.images.first}}
      end

      it "has flash danger" do
        expect(controller).to set_flash[:alert]
          .to I18n.t "devise.failure.unauthenticated"
      end

      it "redirect to root path" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
