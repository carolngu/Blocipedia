class WikisController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]

  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find_by(id: params[:id])
  end

  def new
    @wiki = Wiki.new
    @wiki.user = current_user
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
    if is_private?
      authorize @wiki
    else
      @wiki.private = false
    end
    if @wiki.save
      flash[:notice] = "Wiki has been saved."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error in saving the wiki. Please try again."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find_by(id: params[:id])
  end

  def update
    @wiki = Wiki.find_by(id: params[:id])
    @wiki.assign_attributes(wiki_params)
    if is_private?
      authorize @wiki
    else
      @wiki.private = false
    end
    if @wiki.save
      flash[:notice] = "Wiki has been updated."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error in saving the wiki. Please try again."
      render :edit
    end
  end

  def destroy
    @wiki = Wiki.find_by(id: params[:id])

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error in deleting the wiki."
      render :show
    end
  end

  def add_collaborators
    @wiki = Wiki.find_by(id: params[:id])
    emails_string = params[:emails]
    emails_array = emails_string.split(" ")
    errors = ""
    emails_array.each do |email|
      user = User.find_by(email: email)
      if user
        if user == @wiki.user
          errors << "Collaborator can not be creator of Wiki. "
        else
          c = Collaborator.new(user: user, wiki: @wiki)
          if c.save
            next
          else
            errors << "User #{email} is already a collaborator. "
          end
        end
      else
        errors << "Unable to locate user #{email}. Please try again. "
      end
      if errors.length > 0
        flash[:alert] = errors
      end
    end
    redirect_to action: :edit
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

  def is_private?
    wiki_params[:private].to_i == 1
  end

end
