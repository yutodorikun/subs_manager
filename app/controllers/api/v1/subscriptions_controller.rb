class Api::V1::SubscriptionsController < Api::V1::BaseController
  before_action :set_subscription, only: [:show, :update, :destroy, :toggle_active]
  
  def index
    @subscriptions = current_user.subscriptions.with_category
    render json: @subscriptions, include: :category
  end
  
  def show
    render json: @subscription, include: :category
  end
  
  def create
    @subscription = current_user.subscriptions.build(subscription_params)
    
    if @subscription.save
      render json: @subscription, status: :created, include: :category
    else
      render json: { errors: @subscription.errors }, status: :unprocessable_entity
    end
  end
  
  def update
    if @subscription.update(subscription_params)
      render json: @subscription, include: :category
    else
      render json: { errors: @subscription.errors }, status: :unprocessable_entity
    end
  end
  
  def destroy
    @subscription.destroy
    head :no_content
  end
  
  def toggle_active
    @subscription.update(is_active: !@subscription.is_active)
    render json: @subscription
  end
  
  def statistics
    stats = {
      total_monthly_cost: current_user.subscriptions.active.sum do |sub|
        sub.billing_cycle == 'yearly' ? sub.price / 12 : sub.price
      end,
      total_services: current_user.subscriptions.active.count,
      by_category: current_user.subscriptions.active.joins(:category)
                      .group('categories.name')
                      .sum(:price)
    }
    render json: stats
  end
  
  private
  
  def set_subscription
    @subscription = current_user.subscriptions.find(params[:id])
  end
  
  def subscription_params
    params.require(:subscription).permit(
      :name, :price, :billing_cycle, :start_date, 
      :payment_method, :category_id, :service_url, :notes
    )
  end
end