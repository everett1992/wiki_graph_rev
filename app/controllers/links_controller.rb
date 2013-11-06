class LinksController < ApplicationController
  def from
    from_id = params[:from_id]
    @links = Link.where(from_id: from_id)

    respond_to do |format|
      format.html
      format.json { render json: @links }
    end
  end
end
