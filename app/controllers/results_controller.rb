class ResultsController < ApplicationController
  def index
    @round = Round.new(competition_id: params[:competition_id], category_id: params[:category_id], id: params[:round_id])
  end
end
