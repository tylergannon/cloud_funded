class PagesController < ApplicationController
  def show
    @page = Page.find(params[:id])
    respond_with(@page)
  end
end
