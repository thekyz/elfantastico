class PagesController < ApplicationController
  def home
    @title = "Home"
  end

  def contact
    @title = "Contact"
  end

  def category
    @category = params[:id]
    @title = @category.capitalize
  end
end

