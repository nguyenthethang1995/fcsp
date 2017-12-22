require "rails_helper"
RSpec.describe CoursesController, type: :controller do
  describe "#show" do
    let!(:user){FactoryBot.create :user}
    let!(:course){FactoryBot.create :course}
    let!(:user1){FactoryBot.create :user}

    before(:each, :have_course) do
      sign_in user
      @user_course = FactoryBot.create :user_course, user_id: user1.id,
        course_id: course.id
      get :show, params: {user_id: user1.id, id: course.id}
    end

    before(:each, :my_course) do
      sign_in user
      @user_course = FactoryBot.create :user_course, user_id: user.id,
        course_id: course.id
      get :show, params: {user_id: user.id, id: course.id}
    end

    before(:each, :xhr) do
      sign_in user
      @user_course = FactoryBot.create :user_course, user_id: user.id,
        course_id: course.id
      get :show, params: {user_id: user.id, id: course.id}, xhr: true
    end

    before(:each, :no_course) do
      sign_in user
      get :show, params: {user_id: user.id, id: course.id}
    end

    context "as a guest" do
      it "responses with 302" do
        get :show, params: {user_id: user.id, id: course.id}
        expect(response).to have_http_status "302"
      end

      it "redirect to the sign_in page" do
        get :show, params: {user_id: user.id, id: course.id}
        expect(response).to redirect_to new_user_session_url
      end
    end

    context "when user show user's profile as an authenticated user" do
      it "responses successfully", :my_course do
        expect(response).to be_success
      end

      it "responses with 200", :my_course do
        expect(response).to have_http_status "200"
      end

      it "assigns @users", :my_course do
        expect(assigns(:users).keys).to eq %i(user_shares limit_user_shares
          user_following limit_user_following)
      end

      it "assigns @user_course_subjects", :my_course do
        subject = FactoryBot.create :subject
        user_course_subject = FactoryBot.create :user_course_subject,
          subject_id: subject.id,
          user_id: user.id, course_id: course.id
        expect(assigns :user_course_subjects).to eq [user_course_subject]
      end
    end

    context "when user have permission show profile of other user" do
      before do
        sign_in user
        FactoryBot.create :user_course, user_id: user1.id,
          course_id: course.id
        FactoryBot.create :share_profile,
            user_share_id: user.id, user_shared_id: user1.id
        get :show, params: {user_id: user1.id, id: course.id}
      end

      it "response successfully", :have_course do
        expect(response).to be_success
      end

      it "responses with 200", :have_course do
        expect(response).to have_http_status "200"
      end
    end

    context "when user have not permission show profile of other user" do
      it "response with 302", :have_course do
        expect(response).to have_http_status "302"
      end

      it "redirect to home page", :have_course do
        expect(response).to redirect_to root_url
      end
    end

    context "when request with xhr" do
      it "responds with 200", :xhr do
        expect(response).to have_http_status "200"
      end

      it "responds with JSON formatted output", :xhr do
        expect(response.content_type).to eq "application/json"
      end
    end

    context "when course is not found" do
      it "responses with 302", :no_course do
        expect(response).to have_http_status "302"
      end

      it "redirect to home page", :no_course do
        expect(response).to redirect_to root_url
      end
    end
  end
end
