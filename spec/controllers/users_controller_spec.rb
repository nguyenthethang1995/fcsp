require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "#show" do
    let(:user){FactoryBot.create :user}
    let(:user1){FactoryBot.create :user, role: "trainee"}
    let(:user2){FactoryBot.create :user, role: "trainee"}

    before(:each, :no_xhr) do
      get :show, params: {id: user}
    end

    it "responds successfully", :no_xhr do
      expect(response).to be_success
    end

    it "renders the show template", :no_xhr do
      expect(response).to render_template :show
    end

    it "assigns @users", :no_xhr do
      expect(assigns(:users).keys).to eq %i(user_shares limit_user_shares
        user_following limit_user_following)
    end

    it "assigns @advance_profiles", :no_xhr do
      expect(assigns(:advance_profiles).keys).to eq %i(schools skills languages
        courses)
    end
  end

  describe "#edit" do
    context "as a authenticated user" do
      before do
        @user = FactoryBot.create :user
        sign_in @user
      end

      it "responds successfully" do
        get :edit, params: {id: @user.id}
        expect(response).to be_success
      end

      it "render the edit template" do
        get :edit, params: {id: @user}
        expect(response).to render_template :edit
      end

      it "assigns @info_user" do
        get :edit, params: {id: @user}
        expect(assigns :info_user).to eq @user.info_user
      end

      it "assigns @skill" do
        get :edit, params: {id: @user}
        expect(assigns :skill).to be_a_new(Skill)
      end

      it "assigns @skills" do
        get :edit, params: {id: @user}
        FactoryBot.create :skill_user, user_id: @user.id
        expect(assigns :skills).to eq @user.skill_users
      end
    end

    context "as a unauthenticated user" do
      before do
        user = FactoryBot.create :user
        other_user = FactoryBot.create :user
        sign_in other_user
        get :edit, params: {id: user}
      end

      it "return 302 responds" do
        expect(response).to have_http_status 302
      end

      it "redirect_to root_url" do
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "#update" do
    context "as a authenticated user" do
      let!(:user){FactoryBot.create :user}

      before do
        sign_in user
      end

      it "update successfully" do
        patch :update, params: {id: user, user: {name: "tester"}}
        expect(user.reload.name).to eq "tester"
      end

      it "render json response" do
        patch :update, params: {id: user, user: {name: "tester"}}
        expect(response.content_type).to eq "application/json"
      end

      it "update error with name value is nil" do
        patch :update, params: {id: user, user: {name: ""}}
        expect(response.content_type).to eq "application/json"
      end
    end

    context "as a unauthenticated user" do
      let(:user){FactoryBot.create :user}

      before do
        other_user = FactoryBot.create :user
        sign_in other_user
        patch :update, params: {id: user, user: {name: "tester"}}
      end

      it "return 302 response" do
        expect(response).to have_http_status 302
      end

      it "redirect_to root_url" do
        expect(response).to redirect_to root_url
      end
    end

    context "params type is invalid" do
      let!(:user){FactoryBot.create :user}

      before do
        sign_in user
        patch :update, params: {id: user, user: {"type_missing": "hacker"}}
      end

      it "render json type" do
        expect(response.content_type).to eq "application/json"
      end

      it "render error" do
        message = %({"message":"#{I18n.t('params_error')}"})
        expect(response.body).to eq message
      end
    end
  end

  describe "#update_auto_synchronize" do
    let(:user){FactoryBot.create :user}

    context "update successfully" do
      before do
        sign_in user
        post :update_auto_synchronize,
          params: {id: user, auto_synchronize: true}
      end

      it do
        expect(controller).to set_flash[:success]
          .to(I18n.t "users.update.auto_synchronize_success")
      end

      it "redirect to root path" do
        expect(response).to redirect_to setting_root_path
      end
    end

    context "update error" do
      before do
        sign_in user
        post :update_auto_synchronize, params: {id: user}
      end

      it "update error when params is invalid" do
        expect(controller).to set_flash[:error]
          .to(I18n.t "users.update.auto_synchronize_error")
      end

      it "redirect to root path" do
        expect(response).to redirect_to setting_root_path
      end
    end
  end

  describe "#follow" do
    context "as a authenticated simple user" do
      let!(:user){FactoryBot.create :user}

      before do
        sign_in user
      end

      it "flash message when followed user is invalid" do
        post :follow, params: {id: user.id + 1}
        expect(controller).to set_flash[:alert]
          .to I18n.t("model_not_found", model: "User")
      end

      it "redirect when followed user is invalid" do
        post :follow, params: {id: user.id + 1}
        expect(response).to redirect_to root_url
      end

      it "follow successfully" do
        user_following = FactoryBot.create :user
        expect{post :follow, params: {id: user_following.id}}
          .to change{user.all_following.count}.by 1
      end
    end

    context "as a authenticated Company user" do
      let!(:company){FactoryBot.create :company}
      let!(:user) do
        FactoryBot.create :user, role: "employer", company_id: company.id
      end

      before do
        sign_in user
      end

      it "flash message when followed user is invalid" do
        post :follow, params: {id: user.id + 1}
        expect(controller).to set_flash[:alert]
          .to I18n.t("model_not_found", model: "User")
      end

      it "redirect when follow error" do
        post :follow, params: {id: user.id + 1}
        expect(response).to redirect_to root_url
      end

      it "follow successfully" do
        user_following = FactoryBot.create :user
        expect{post :follow, params: {id: user_following.id}}
          .to change{company.all_following.count}.by 1
      end

      it "render json when follow successfully" do
        user_following = FactoryBot.create :user
        post :follow, params: {id: user_following.id}
        expect(response.content_type).to eq "application/json"
      end
    end

    context "as a unauthenticated user" do
      before do
        user_following = FactoryBot.create :user
        post :follow, params: {id: user_following.id}
      end

      it "return 302 response" do
        expect(response).to have_http_status 302
      end

      it "redirect_to root_url" do
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "#unfollow" do
    context "as a authenticated simple user" do
      let!(:user){FactoryBot.create :user}

      before do
        sign_in user
      end

      it "flash message when unfollowed user is invalid" do
        post :unfollow, params: {id: user.id + 1}
        expect(controller).to set_flash[:alert]
          .to I18n.t("model_not_found", model: "User")
      end

      it "redirect when unfollowed user is invalid" do
        post :unfollow, params: {id: user.id + 1}
        expect(response).to redirect_to root_url
      end

      it "unfollow successfully" do
        user_following = FactoryBot.create :user
        user.follow user_following
        expect{post :unfollow, params: {id: user_following.id}}
          .to change{user.all_following.count}.by -1
      end
    end

    context "as a authenticated Company user" do
      let!(:company){FactoryBot.create :company}
      let!(:user) do
        FactoryBot.create :user, role: "employer", company_id: company.id
      end

      before do
        sign_in user
      end

      it "flash message when unfollowed user is invalid" do
        post :unfollow, params: {id: user.id + 1}
        expect(controller).to set_flash[:alert]
          .to I18n.t("model_not_found", model: "User")
      end

      it "redirect when unfollow error" do
        post :unfollow, params: {id: user.id + 1}
        expect(response).to redirect_to root_url
      end

      it "unfollow successfully" do
        user_following = FactoryBot.create :user
        company.follow user_following
        expect{post :unfollow, params: {id: user_following.id}}
          .to change{company.all_following.count}.by -1
      end

      it "render json when unfollow successfully" do
        user_following = FactoryBot.create :user
        post :unfollow, params: {id: user_following.id}
        expect(response.content_type).to eq "application/json"
      end
    end

    context "as a unauthenticated user" do
      before do
        user_following = FactoryBot.create :user
        post :unfollow, params: {id: user_following.id}
      end

      it "return 302 response" do
        expect(response).to have_http_status 302
      end

      it "redirect_to root_url" do
        expect(response).to redirect_to new_user_session_url
      end
    end
  end
end
