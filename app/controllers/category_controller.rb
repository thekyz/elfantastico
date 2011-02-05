class CategoryController < ApplicationController

  def show
    @category = params[:id]
    @title = @category.capitalize
  end
end

