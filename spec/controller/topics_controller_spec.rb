require 'rails_helper'

RSpec.describe TopicsController, type: :controller do
  before(:all) do
    @admin_user = User.create(username: "admin_user", email: "admin@gmail.com", password: "password", role: "admin")
    @user = User.create(username: "own", email: "own@gmail.com", password: "password")
    @topic = Topic.create(title: "TopicTitle", description: "TopicDescription TDD testing", user_id: "1")

  end

  describe "index" do
    it "should render index" do
      get :index
      expect(subject).to render_template(:index)
    end
  end

  describe "new topic" do
    it "should deny if not logged in" do
        get :new
        expect(flash[:danger]).to eql("You need to login first")
    end

    it "should render new for admin" do
        get :new, params: nil, session: { id: @admin_user.id }
        expect(subject).to render_template(:new)
    end

    it "should deny user" do
        cookies.signed[:id] = @user.id
        get :new, params: nil
        expect(flash[:danger]).to eql("You need to login first")
    end
  end

  describe "create" do

    it "should redirect if not logged in" do

      params = { topic: { title: "NewTopicTitle", description: "NewTopicDescription" }}
      post :create, params: params

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end
    # it "should deny if not logged in" do
    #      params = { topic: { title: "NewTopicTitle", description: "NewTopicDescription" } }
    #      post :create, params: params
    #
    #      expect(flash[:danger]).to eql("You need to login first")
    #  end

   it "should create new topic for admin" do
       params = { topic: { title: "NewTitle", description: "New TitleDescription TDD testing" } }
       post :create, params: params, session: { id: @admin_user.id }
       topic = Topic.find_by(title: "NewTitle")

       expect(Topic.count).to eql(2)
       expect(topic).to be_present
       expect(topic.description).to eql("New TitleDescription TDD testing")
       expect(subject).to redirect_to(topics_path)
   end
 end

   describe "edit topic" do
      it "should redirect if not logged in" do
          user_id = { id: @user.id }
          get :edit, params: user_id

          expect(subject).to redirect_to(root_path)
          expect(flash[:danger]).to eql("You need to login first")
      end

      it "should redirect if user unauthorized" do
            params = { id: @admin_user.id }
            get :edit, params: params, session: { id: @user.id }

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You're not authorized")
      end

      it "should render edit" do
          params = { id: @admin_user.id }
          get :edit, params: params, session: { id: @admin_user.id }

          current_user = subject.send(:current_user)
          expect(subject).to render_template(:edit)
          expect(current_user).to be_present

      end
    end

    describe "update topic" do

    it "should redirect if not logged in" do
      params = { id: @topic.id, topic: { title: "NewTopic", description: "New TopicDescription TDD testing"} }
      patch :update, params: params
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { id: @topic.id, topic: { title: "NewTopic", description: "New TopicDescription TDD testing"} }
      patch :update, params: params, session: { id: @user.id }
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update topic" do
      params = { id: @topic.id, topic: { title: "NewTopic", description: "New TopicDescription TDD testing"} }
      patch :update, params: params, session: { id: @admin_user.id }

      @topic.reload

      expect(@topic.title).to eql("NewTopic")
      expect(@topic.description).to eql("New TopicDescription TDD testing")
    end

  end

    describe "destroy topic" do
        it "should redirect if not logged in" do
            params = { id: @user.id }
            get :destroy, params: params

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You need to login first")
        end

        it "should redirect if user unauthorized" do
            params = { id: @admin_user.id }
            get :destroy, params: params, session: { id: @user.id }

            expect(subject).to redirect_to(root_path)
            expect(flash[:danger]).to eql("You're not authorized")
        end

        it "should render destroy" do
            params = { id: @admin_user.id }
            get :destroy, params: params, session: { id: @admin_user.id }

            current_user = subject.send(:current_user)
            expect(subject).to redirect_to(topics_path)
            expect(current_user).to be_present
        end
      end

end
