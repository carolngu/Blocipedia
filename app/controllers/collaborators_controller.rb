class CollaboratorsController < ApplicationController
  def destroy
    c = Collaborator.find_by(id: params[:id])
    wiki = c.wiki
    if c.destroy
      flash[:notice] = "Collaborator #{c.user.email} has been removed."
    else
      flash.now[:alert] = "There was an error in removing collaborator. Please try again"
    end
    redirect_to edit_wiki_path(wiki)
  end

  def create
    email = params[:email]
    @wiki = Wiki.find_by(id: params[:wiki_id])
    @user = User.find_by(email: email)
    if @user
      @collaborator = Collaborator.new(wiki: @wiki, user: @user)
      if @collaborator.save
        flash[:notice] = "Added #{email} as a collaborator."
      else
        flash[:alert] = "There was a problem adding #{email}. Please try again."
      end
    else
      flash[:alert] = "Could not find #{email}. Please try again."
    end
    redirect_to edit_wiki_path(@wiki)
  end
end
