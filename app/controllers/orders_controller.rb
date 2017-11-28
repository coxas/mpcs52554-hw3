class OrdersController < ApplicationController
  protect_from_forgery with: :null_session

  def index
  end 

  def show
  end 

  def new
    @order = Order.new
  end 

  def create
    Rails.logger.warn params
    user_api_key = request.query_parameters["apikey"]
    sku = params["sku"]
    # assume that when an order goes through it is immediately added to the shipping queue and status immediately marked as preparing for shipment
    status = "Preparing for Shipment"
    quantity = params["quantity"]
    address = params["address"]
    @user = User.find_by(api_key: user_api_key)
    if @user != nil
        @item = Item.find_by(user_id: @user.id, sku: sku, status: status)
        if @item != nil #if there are already some preparing for shipment
            prev_quant = @item.quantity
            add_quant = params["quantity"]
            new_quant = prev_quant.to_i + add_quant.to_i
            @item.quantity = new_quant
            @item2 = Item.find_by(user_id: @user.id, sku: sku, status: "In Stock")
            prev_quant = @item2.quantity
            minus_quant = params["quantity"]
            new_quant = prev_quant.to_i - minus_quant.to_i
            @item2.quantity = new_quant
            if new_quant < 0 
                msg = {"Error":"You don't have enough items in stock!"}
                render json: msg
            else
                @item2.save
                @order = Order.new
                @order.user_id = @user.id
                @order.quantity = params["quantity"]
                @order.sku = params["sku"]
                @order.address = params["address"]
                if @item.save && @order.save
                    msg = {"Thanks for submitting your post request!":""}
                    render json: msg
                    # render json: @order
                else 
                    msg = {"Error": "Your POST request was not processed."}
                    render json: msg
                end 
            end 
        else 
            @item = Item.new
            user_api_key = request.query_parameters["apikey"]
            @user = User.find_by(api_key: user_api_key)
            @item.user_id = @user.id
            @item.status = "Preparing for Shipment"
            @item.sku = params["sku"]
            @item.quantity = params["quantity"]
            @item2 = Item.find_by(user_id: @user.id, sku: sku, status: "In Stock")
            prev_quant = @item2.quantity
            minus_quant = params["quantity"]
            new_quant = prev_quant.to_i - minus_quant.to_i
            @item2.quantity = new_quant
            if new_quant < 0 
                msg = {"Error": "You don't have enough items in stock!"}
                render json: msg
            else    
                @item2.save
                @order = Order.new
                @order.user_id = @user.id
                @order.quantity = params["quantity"]
                @order.sku = params["sku"]
                @order.address = params["address"]
                if @item.save && @order.save
                    msg = {"Thanks for submitting your post request!": ""}
                    render json: msg
                    # render json: @order
                else 
                    msg = {"Error": "Your POST request was not processed."}
                    render json: msg
                end 
            end 
        end
    else     
         render text: "Error: Your user was not found in the database."
    end 
end 
end 

