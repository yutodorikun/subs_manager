class Api::V1::AlternativePlansController < Api::V1::BaseController
  def index
    @plans = AlternativePlan.all
    render json: @plans
  end
  
  def by_category
    @plans = AlternativePlan.where(category_id: params[:category_id])
    render json: @plans
  end
end