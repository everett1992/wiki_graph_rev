class SearchController < ApplicationController
  def search
    @wiki = Wiki.find_by_title params[:wiki][:title]
    # TODO: Wiki title does not match a wiki
    #     -> flash error message
    if @wiki
      # Random is true, -> return random page from selected wiki
      if params[:random] == "true"
        redirect_to [@wiki, @wiki.random_page(1)]
      end

      @pages = Page.where wiki: @wiki, title: params[:page][:title]

      # Page Title matches one page exactly -> return that page
      if @pages.count == 1
        redirect_to [@wiki, @pages.first]
      #elsif pages.count > 0
      #  # TODO: Page Title matches many pages -> List those pages
      #else
      #  # TODO: Page title does not match any pages -> flash error message
      end

    end
  end
end
