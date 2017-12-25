require "rails_helper"

RSpec.describe InfoUsersController, type: :controller do
  let!(:user){FactoryBot.create :user}
  let!(:info_user){FactoryBot.create :info_user, user: user}
  let!(:another_user){FactoryBot.create :user}

  before(:each, :sign_in_user) do
    sign_in user
  end

  before(:each, :sign_in_another_user) do
    sign_in another_user
  end

  describe "update" do
    context "valid type phone and input_info_user", :sign_in_user do
      before do
        input_info_user_hash = {
          gender: "female",
          relationship_status: "married",
          introduction: Faker::Lorem.sentence,
          ambition: Faker::Lorem.sentence,
          quote: Faker::Lorem.sentence,
          address: FFaker::Lorem.sentence,
          phone: FFaker::PhoneNumber.short_phone_number,
          birthday: FFaker::Time.date,
          occupation: FFaker::Job.title,
          country: FFaker::Address.city
        }

        info_user_params = %i(introduction ambition quote address phone
          relationship_status gender birthday occupation country).sample

        patch :update, params: {id: info_user,
          type: info_user_params,
          input_info_user: input_info_user_hash[info_user_params]}
      end

      it "response success" do
        expect(response).to be_success
      end

      it "respone with JSON" do
        expect(response.content_type).to eq "application/json"
      end
    end

    context "without signin" do
      before do
        patch :update, params: {id: info_user, type: "phone",
          input_info_user: "01"}
      end

      it "redirect to sign in page" do
        expect(response).to redirect_to new_user_session_path
      end

      it "have status 302" do
        expect(response).to have_http_status 302
      end

      it "has flash unauthenticated" do
        expect(controller).to set_flash[:alert]
          .to I18n.t "devise.failure.unauthenticated"
      end
    end

    context "invalid input_info_user", :sign_in_user do
      let(:old_quote){info_user.quote}
      let(:old_introduction){info_user.introduction}
      let(:old_ambition){info_user.ambition}

      before(:each, :max_quote) do
        patch :update, params: {id: info_user, type: "quote",
          input_info_user: FFaker::Lorem
            .sentence(Settings.info_users.max_length_quote + 1)}
      end

      before(:each, :max_introduction) do
        patch :update, params: {id: info_user, type: "introduction",
          input_info_user: FFaker::Lorem
            .sentence(Settings.info_users.max_length_introduce + 1)}
      end

      before(:each, :max_ambition) do
        patch :update, params: {id: info_user, type: "ambition",
          input_info_user: FFaker::Lorem
            .sentence(Settings.info_users.max_length_ambition + 1)}
      end

      it "update failed with more max length quote", :max_quote do
        expect(assigns(:info_user).reload.quote).to eq old_quote
      end

      it "response to JSON with more max length quote", :max_quote do
        expect(response.content_type).to eq "application/json"
      end

      it "update failed with more max length introduction",
        :max_introduction do
        expect(assigns(:info_user).reload.introduction)
          .to eq old_introduction
      end

      it "response to JSON with more max length introduction",
        :max_introduction do
        expect(response.content_type).to eq "application/json"
      end

      it "update failed with more max length ambition", :max_ambition do
        expect(assigns(:info_user).reload.ambition).to eq old_ambition
      end

      it "response to JSON with more max length ambition", :max_ambition do
        expect(response.content_type).to eq "application/json"
      end
    end

    context "update with another user", :sign_in_another_user do
      before do
        patch :update, params: {id: info_user, type: "phone",
          input_info_user: ""}
      end

      it "update failed and redirect to root path" do
        expect(response).to redirect_to root_path
      end

      it "flash danger with messages" do
        expect(controller).to set_flash[:danger]
          .to I18n.t "info_users.update.info_user_not_found"
      end
    end
  end

  describe "index" do
    before(:each, :is_public_false) do
      get :index
    end

    before(:each, :is_public_true) do
      info_user.update_attributes is_public: true
      get :index
    end

    context "is_public is false", :sign_in_user, :is_public_false do
      it "change public success to true" do
        expect(assigns(:info_user).is_public).to eq true
      end

      it "redirect after change public success" do
        expect(info_user).to redirect_to user_path user
      end
    end

    context "is_public is true", :sign_in_user, :is_public_true do
      it "change public success to false" do
        expect(assigns(:info_user).is_public).to eq false
      end

      it "redirect after change public success" do
        expect(info_user).to redirect_to user_path user
      end
    end

    context "without signin", :is_public_false do
      it "redirect to signin page" do
        expect(response).to redirect_to new_user_session_path
      end

      it "has status 302" do
        expect(response).to have_http_status 302
      end
    end

    context "with another user", :sign_in_another_user, :is_public_false do
      it "redirect to root path" do
        expect(response).to redirect_to root_path
      end

      it "has status 302" do
        expect(response).to have_http_status 302
      end
    end
  end
end
