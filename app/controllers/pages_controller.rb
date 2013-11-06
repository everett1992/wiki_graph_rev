class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  # GET /pages/1
  # GET /pages/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find_by_title(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:title)
    end
end
