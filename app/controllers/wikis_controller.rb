class WikisController < ApplicationController
  before_action :set_wiki, only: [:random_page, :titles, :show, :edit, :update, :destroy]

  # GET /wikis
  # GET /wikis.json
  def index
    @wikis = Wiki.all
  end

  # GET /wikis/1
  # GET /wikis/1.json
  def show
  end

  # GET /wikis/new
  def new
    @wiki = Wiki.new
  end

  # GET /wikis/1/edit
  def edit
  end

  # POST /wikis
  # POST /wikis.json
  def create
    @wiki = Wiki.new(wiki_params)

    respond_to do |format|
      if @wiki.save
        format.html { redirect_to @wiki, notice: 'Wiki was successfully created.' }
        format.json { render action: 'show', status: :created, location: @wiki }
      else
        format.html { render action: 'new' }
        format.json { render json: @wiki.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wikis/1
  # PATCH/PUT /wikis/1.json
  def update
    respond_to do |format|
      if @wiki.update(wiki_params)
        format.html { redirect_to @wiki, notice: 'Wiki was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @wiki.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wikis/1
  # DELETE /wikis/1.json
  def destroy
    @wiki.destroy
    respond_to do |format|
      format.html { redirect_to wikis_url }
      format.json { head :no_content }
    end
  end

  def titles
    query = params[:q]
    if query
      @titles = @wiki.pages.where("title LIKE :prefix", prefix: "#{query}%").pluck(:title)
    else
      @titles = @wiki.pages.pluck(:title)
    end

    respond_to do |format|
      format.html
      format.json { render json: @titles }
    end
  end

  # Redirect to a random page, ensuring it has at least one link
  def random_page
    c = @wiki.pages.count
    begin
      @page = @wiki.pages.find(:first, offset: rand(c))
    end while @page.links.count < 1

    redirect_to [@wiki, @page]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wiki
      @wiki = Wiki.find_by_title(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wiki_params
      params.require(:wiki).permit(:title, :page_id)
    end
end
