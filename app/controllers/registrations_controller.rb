class RegistrationsController < Devise::RegistrationsController

  def edit
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Premium Membership - #{current_user.name}",
      amount: Amount.default
    }
    super
  end

  def downgrade
    if current_user.is_premium?
      current_user.role = "standard"
      current_user.wikis.update_all(private: false)

      if current_user.save!
        flash[:notice] = "Your membership has been changed to standard."
        redirect_to action: :edit
      else
        flash.now[:alert] = "There was an error in downgrading your membership. Please try again."
        redirect_to action: :edit
      end
    else
      redirect_to action: :edit
    end
  end
end
