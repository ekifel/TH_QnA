class SearchController < ApplicationController
  skip_authorization_check

  def search
    @search = SphinxSearchService.new(search_params)
    @search.call
  end

  private

  def search_params
    params.require(:search).permit(:q, :section)
  end
end
