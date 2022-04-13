require "rails_helper"

# RSpec.describe EndUsersController, "コントローラに関するテスト", type: :controller do
  describe "[Action test]" do
    before do
      @end_user = FactoryBot.build(:end_user)
    end
    
    context "new" do
      it "ログインしていない場合はアクセスできない" do
        get "/spots/new"
        expect(response).to have_http_status(401)
      end
    end
    
  end
# end