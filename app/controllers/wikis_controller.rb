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
    @collaborator = Collaborator.new
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

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

  def is_private?
    wiki_params[:private].to_i == 1
  end

end
