require "rails_helper"

RSpec.describe EndUser, "モデルに関するテスト", type: :model do
  
  describe "end_userの登録" do
    context "有効な内容をpushした場合" do
      it "データが保存されること" do
        expect(FactoryBot.build(:end_user)).to be_valid
      end
    end
    
    context "未入力でpushした場合" do
      it "nameが未入力の場合にバリデーションチェックされエラーメッセージが表示される" do
        end_user = EndUser.new(name: '')
        expect(end_user).to be_invalid
        expect(end_user.errors[:name]).to include("が入力されていません。")
      end
      it "emailが未入力の場合にバリデーションチェックされエラーメッセージが表示される" do
        end_user = EndUser.new(email: "")
        expect(end_user).to be_invalid
        expect(end_user.errors[:email]).to include("が入力されていません。")
      end
      it "passwordが未入力の場合にバリデーションチェックされエラーメッセージが表示される" do
        end_user = EndUser.new(password: "")
        expect(end_user).to be_invalid
        expect(end_user.errors[:password]).to include("が入力されていません。")
      end
      it "password_confirmationが未入力の場合にバリデーションチェックされエラーメッセージが表示される" do
        end_user = EndUser.new(password_confirmation: "")
        expect(end_user).to be_invalid
        expect(end_user.errors[:password_confirmation]).to include("が内容とあっていません。")
      end
    end
    
    context "無効な内容をpushした場合" do 
      it "nameが10文字以上の場合にバリデーションチェックされエラーメッセージが表示される" do
      end_user = EndUser.new(name: "hogehogehoge")
      expect(end_user).to be_invalid
      expect(end_user.errors[:name]).to include("は10文字以下に設定して下さい。")
      end
      it "introductionが500文字以上の場合にバリデーションチェックされエラーメッセージが表示される" do
        end_user = EndUser.new(introduction: Faker::Lorem.characters(number:501))
        expect(end_user).to be_invalid
        expect(end_user.errors[:introduction]).to include("は500文字以下に設定して下さい。")
      end
    end
    
  end
end