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
end
