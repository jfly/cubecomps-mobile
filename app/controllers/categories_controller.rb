class CategoriesController < ApplicationController
  def index
    @competition = Competition.find(params[:competition_id])
  end
end
