class WikisController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]

  def index
    @wikis = Wiki.visible_to(current_user)
  end

  def show
    @wiki = Wiki.find_by(id: params[:id])
  end

  def new
    @wiki = Wiki.new
  end

  def create
    @wiki = Wiki.new(wiki_params)


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
    authorize @wiki 

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

end
