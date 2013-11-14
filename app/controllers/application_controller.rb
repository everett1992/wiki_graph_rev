class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def search
    # Wiki title does not match a wiki
    #     -> flash error message
    # Random is true, -> return random page from selected wiki
    # Page Title matches one page exactly -> return that page
    # Page Title matches many pages -> List those pages
    # Page title does not match any pages
    #     -> flash error message
  end
end
