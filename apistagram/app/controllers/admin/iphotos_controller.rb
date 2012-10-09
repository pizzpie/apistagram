class Admin::IphotosController < ApplicationController
  layout 'admin'

  before_filter :authenticate_user!, :authenticate_admin_user

  def index
    @iphotos = Iphoto.page(params[:page]).pending
  end
  
  def approve_photos
    @prev_count     = Iphoto.selected.count
    result          = Iphoto.update_all_with_callbacks(params[:iphoto_ids], params["all_photo_ids"])
    @new_count      = Iphoto.selected.count

    removed_count = result[1]
    approved_count = result[0]
    
    redirect_to admin_iphotos_path, :notice => "#{approved_count} photos approved and #{removed_count} removed."
  end
end
