require "rails_helper"

describe "end_usersコントローラに関するテスト" do
  let(:end_user) { FactoryBot.create(:end_user) }
  other_user = FactoryBot.create(:end_user) 

  before do
    visit new_end_user_session_path
    fill_in "end_user[email]", with: end_user.email
    fill_in "end_user[password]", with: end_user.password
    click_button "ログイン"
  end
  
  context "[Action]show" do
    it "マイページの場合は編集ボタンが表示される" do
      visit end_user_path(end_user)
      expect(page).to have_link "編集"
    end
    it "他のユーザーの詳細画面の場合はフォローボタンが表示される" do
      visit end_user_path(other_user)
      expect(page).to have_link "follow" || "unfollow"
    end
    it "followsリンクが表示されリンクを押すとフォロー一覧画面へ遷移する" do
      visit end_user_path(end_user)
      expect(page).to have_link "follows"
      click_on "follows"
      expect(page).to have_current_path end_user_followings_path(end_user)
    end
    it "followersリンクが表示されリンクを押すとフォロワー一覧画面へ遷移する" do
      visit end_user_path(end_user)
      expect(page).to have_link "followers"
      click_on "followers"
      expect(page).to have_current_path end_user_followers_path(end_user)
    end
    it "favoritesリンクが表示されリンクを押すとお気に入り一覧画面へ遷移する" do
      visit end_user_path(end_user)
      expect(page).to have_link "favorites"
      click_on "favorites"
      expect(page).to have_current_path collection_end_user_path(end_user)
    end
  end
  
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