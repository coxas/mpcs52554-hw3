class ItemsController < ApplicationController
  protect_from_forgery with: :null_session
# before_action :require_login

#     def require_login
#         @user = User.find_by(id: session[:user_id])
#         if @user.blank?
#             redirect_to root_url, notice: "Please sign up or sign in to use Warehouse on the Web."
#         end
#     end

  def index
    Rails.logger.warn request.query_parameters    
    user_api_key = request.query_parameters["apikey"]
    @user = User.find_by(api_key: user_api_key)
    # Rails.logger.warn "user is:"
    # Rails.logger.warn @user
    # Rails.logger.warn "that was the user"
    if @user != nil
      @items = Item.where(user_id: @user.id)
      render :json => @items
    else
      redirect_to "/", notice: 'There was an error retrieving your data.'
    end 
  end

  def show 
    Rails.logger.warn request.query_parameters
    user_api_key = request.query_parameters["apikey"]
    sku = params["sku"]
    Rails.logger.warn params
    @user = User.find_by(api_key: user_api_key) 
    if @user != nil
     @items = Item.where(user_id: @user.id, sku: sku)
     render :json => @items
    else
     redirect_to "/", notice: 'There was an error retrieving your items.'
    end 
  end 

  def new 
    @item = Item.new
  end

  def create
    Rails.logger.warn params
    user_api_key = request.query_parameters["apikey"]
    sku = params["sku"]
    status = params["status"]
    quantity = params["quantity"]
    @user = User.find_by(api_key: user_api_key) 
    if @user != nil
     @item = Item.find_by(user_id: @user.id, sku: sku, status: status)
     if @item != nil
      prev_quant = @item.quantity
      add_quant = params["quantity"]
      new_quant = prev_quant.to_i + add_quant.to_i
      @item.quantity = new_quant
      if @item.save 
        msg = {"Thanks for submitting your POST request.":""}
        render json: msg
      else 
        msg = {"Error": "Your POST request was not processed."}
        render json: msg
      end 
    else 
      @item = Item.new
      user_api_key = request.query_parameters["apikey"]
      @user = User.find_by(api_key: user_api_key)
      @item.user_id = @user.id
      @item.status = params["status"]
      @item.sku = params["sku"]
      @item.quantity = params["quantity"]
      if @item.save
        msg = {"Thanks for submitting your POST request.": ""}
        render json: msg
      else 
        msg = {"Error": "Your POST request was not processed."}
        render json: msg
      end 
    end

    else 
      msg = {"Error": "Your user was not found in the database."}
      render json: msg
    end 
  end 
      
    




    # else
    #  redirect_to "/", notice: 'There was an error retrieving your items.'
    # end 
    
    # @item = params[:]
  #   @item = Item.find_by(item: params["sku"])

  #   if @item != nil && @item.status == params["status"]
  #     @item.quantity = params["quantity"]
  #     if @item.save
  #       redirect_to "/items", notice: ''
  #     else
  #       redirect_to "/items/new", notice: 'Oops, something went wrong.'
  #     end 
  #   else 
  #     @item = Item.new
  #     @item.user_id = params["user_id"]
  #     @item.status = params["status"]
  #     @item.sku = params["sku"]
  #     @item.quantity = params["quantity"]
   
  #     if @item.save
  #       redirect_to "/items", notice: ''
  #     else
  #       redirect_to "/items/new", notice: 'Oops, something went wrong.'
  #     end
  #   end
  # end 

  def destroy 

  end
end