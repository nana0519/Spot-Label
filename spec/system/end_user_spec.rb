require "rails_helper"

describe "EndUsersコントローラに関するテスト" do
  let(:end_user) { FactoryBot.create(:end_user) }
  user1 = FactoryBot.create(:end_user) 

  before do
    visit new_end_user_session_path
    fill_in "end_user[email]", with: end_user.email
    fill_in "end_user[password]", with: end_user.password
    click_button "ログイン"
  end
  
  # context "[Action]show" do
  #   before do
  #     visit end_user_path(end_user)
  #   end
  #   it "current_end_userの場合は編集ボタンが表示される" do
  #   end
  # end
      

  context "[Action]edit" do
    before do
      visit edit_end_user_path(end_user)
    end
    it "編集前の内容がフォームに表示されている" do
      expect(page).to have_field "end_user[name]", with: end_user.name
      expect(page).to have_field "end_user[email]", with: end_user.email
      expect(page).to have_field "end_user[introduction]", with: end_user.introduction
    end
    it "更新処理に成功し、マイページへ遷移する" do
      fill_in "end_user[name]", with: Faker::Name.name
      fill_in "end_user[email]", with: Faker::Internet.email
      fill_in "end_user[introduction]", with: "こんにちは！"
      click_button "変更"
      expect(page).to have_current_path end_user_path(end_user)
    end
    it "退会リンクを押すと退会確認画面へ遷移する" do
      click_on "退会"
      expect(page).to have_current_path unsubscribe_end_users_path
    end
  end

  context "[Action]withdraw" do
    before do
      visit unsubscribe_end_users_path
    end
    it "退会しないリンクを押すとspot一覧画面へ遷移する" do
      click_on "退会しない"
      expect(page).to have_current_path spots_path
    end
    it "退会するリンクを押すと退会する" do
      click_on "退会する"
      expect(end_user.reload.is_deleted).to eq true
      expect(page).to have_current_path root_path
    end
  end
end
