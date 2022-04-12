require "rails_helper"

RSpec.describe Spot, "モデルに関するテスト", type: :model do
  describe "Spotの登録" do
    
    context "有効な内容をpushした場合" do
      it "データが保存される" do
        expect(FactoryBot.build(:spot)).to be_valid
      end
    end
    
    context "未入力でpushした場合" do
      it "addressが未入力の場合にバリデーションチェックされエラーメッセージが表示される" do
        spot = Spot.new(address: "")
        expect(spot).to be_invalid
        expect(spot.errors[:address]).to include("が入力されていません。") 
      end
    end
    
  end
end