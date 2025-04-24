class ContactsController < ApplicationController
  before_action :set_contact, only: %i[ show edit update destroy ]

  def index
    @contacts = Contact.all
    
    if params[:search_by_name] && params[:search_by_name] != ""
      @contacts = @contacts.where("name like ?", 
      "%#{params[:search_by_name]}%")
    end
   if params[:search_by_email] && params[:search_by_email] != ""
      @contacts = @contacts.where("email like ?", 
      "%#{params[:search_by_email]}%")
    end
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to @contact, notice: "Contact was successfully created."
    else
      if @contact.errors[:email].include?("has already been taken")
        @contact.errors.delete(:email)
        @contact.errors.add(:base, "There was a problem saving this contact. Please try again.")
      end
      render :new, status: :unprocessable_entity
    end
  end
  

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update(contact_params)
      redirect_to @contact
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @contact.destroy
    redirect_to contacts_path
  end

  private
    def set_contact
      @contact = Contact.find(params[:id])
    end

    def contact_params
      params.require(:contact).permit(:name, :email)
    end
end
