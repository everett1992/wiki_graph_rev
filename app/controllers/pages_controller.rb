class PagesController < ApplicationController
  before_action :set_wiki, only: [:show]
  before_action :set_page, only: [:show, :connected_component, :info]

  respond_to :json, :html
  # GET /pages/1
  # GET /pages/1.json
  def show
  end

  def info
  end

  def connected_component
    @cc =  @page.connected_component
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      if @wiki
        @page = @wiki.pages.find(params[:id])
      else
        @page = Page.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:title)
    end

    def set_wiki
      @wiki = Wiki.find_by_title(params[:wiki_id])
    end
end
