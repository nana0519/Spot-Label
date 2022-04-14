require "rails_helper"

describe "EndUsersコントローラに関するテスト" do
  let(:end_user) { FactoryBot.create(:end_user) }
  
  # before do
  #   visit new_end_user_registration_path
  #   fill_in 'end_user[name]', with: end_user.name
  #   fill_in 'end_user[email]', with: end_user.email
  #   fill_in 'end_user[password]', with: end_user.password
  #   fill_in 'end_user[password_confirmation]', with: end_user.password_confirmation
  #   click_button "新規登録"
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
  end

end
