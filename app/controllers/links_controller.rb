class LinksController < ApplicationController
  def from
    from_ids = ActiveSupport::JSON.decode(params[:pages])
    @links = Link.where(from_id: from_ids)

    respond_to do |format|
      format.html
      format.json { render json: @links }
    end
  end
end
