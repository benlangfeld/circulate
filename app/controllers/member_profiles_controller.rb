class MemberProfilesController < ApplicationController
    def show
      @member = Member.first
    end

    def edit
    end

    def update
      respond_to do |format|
        if current_member.update(member_params)
          format.html { redirect_to :member_profile, success: "Item was successfully updated." }
          format.json { render :show, status: :ok, location: current_member }
        else
          format.html { render :edit }
          format.json { render json: @item.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def member_params
      params.require(:member).permit(:full_name,
                                     :preferred_name,
                                     :pronoun,
                                     :custom_pronoun,
                                     :email,
                                     :phone_number,
                                     :address1,
                                     :address2,
                                     :postal_code,
                                     :desires,
                                     :reminders_via_email,
                                     :reminders_via_text,
                                     :receive_newsletter,
                                     :volunteer_interest)
    end
end
