class Public::ContactsController < ApplicationController
  before_action :authenticate_end_user!

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.contact_mail(@contact, current_end_user).deliver
      redirect_to request.referer, notice: "お問い合わせ内容を送信しました"
    else
      render "new"
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :content)
  end
end
