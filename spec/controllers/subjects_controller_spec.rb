require "rails_helper"

RSpec.describe SubjectsController, type: :controller do
  describe "#show" do
    let!(:user){FactoryBot.create :user}
    let!(:course){FactoryBot.create :course}
    let!(:subject){FactoryBot.create :subject}

    let!(:user_course_subject) do
      FactoryBot.create :user_course_subject, user_id: user.id,
        course_id: course.id, subject_id: subject.id
    end

    before do
      FactoryBot.create :user_course, user_id: user.id, course_id: course.id
    end

    context "as a authenticated user who have permission profie" do
      before do
        allow_any_instance_of(SubjectsController)
          .to receive(:check_permission_profile).with(user).and_return true
        sign_in user
      end

      before(:each, :not_xhr) do
        get :show, params: {user_id: user.id, course_id: course.id,
          id: user_course_subject.id}
      end

      it "response successfully", :not_xhr do
        expect(response).to be_success
      end

      it "render the show template", :not_xhr do
        expect(response).to render_template :show
      end

      it "assigns @user_task", :not_xhr do
        task = FactoryBot.create :task, subject_id: subject.id
        user_task = FactoryBot.create :user_task, course_id: course.id,
          subject_id: subject.id, user_id: user.id, task_id: task.id
        expect(assigns :user_tasks).to include user_task
      end

      it "assigns @users", :not_xhr do
        expect(assigns(:users).keys).to eq %i(user_shares limit_user_shares
          user_following limit_user_following)
      end

      it "render json with xhr" do
        get :show, params: {user_id: user.id, course_id: course.id,
          id: user_course_subject.id}, xhr: true
        expect(response.content_type).to eq "application/json"
      end
    end

    context "as a authenticated user who don't have permission profile" do
      let!(:other_user){FactoryBot.create :user}

      before do
        sign_in other_user
        get :show, params: {user_id: user.id, course_id: course.id,
          id: user_course_subject.id}
      end

      it "response successfully" do
        expect(response).to have_http_status 302
      end

      it "notify error permission" do
        expect(controller).to set_flash[:alert]
          .to I18n.t "page_error"
      end

      it "render the show template" do
        expect(response).to redirect_to root_url
      end
    end

    context "as a unauthenticated user" do
      before do
        get :show, params: {user_id: user.id, course_id: course.id,
          id: user_course_subject.id}
      end

      it "render http status 302" do
        expect(response).to have_http_status 302
      end

      it "redirect to signin page" do
        expect(response).to redirect_to new_user_session_url
      end

      it "notify error permission" do
        expect(controller).to set_flash[:alert]
          .to I18n.t "devise.failure.unauthenticated"
      end
    end

    context "subject is not found" do
      before do
        sign_in user
        get :show, params: {user_id: user.id, course_id: course.id,
          id: user_course_subject.id + 1}
      end

      it "redirect to root_url" do
        expect(response).to redirect_to root_url
      end

      it "notify not found" do
        expect(controller).to set_flash[:alert]
          .to I18n.t "model_not_found", model: "UserCourseSubject"
      end
    end
  end
end
