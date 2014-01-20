class ShoppingCartsController < ApplicationController

  def show
    #only show carts which are availabe to the user session
    get_visitor_cart
      
    if @shopping_cart.total_unique_items > 0
      render "show"
    else
      render "empty"
    end
  end
  
  
  
  def update
    get_visitor_cart
    
    # for now, assume that only the PhotoPrintOption class can be added to the card
    # this captures the photo and the size option all in one go
    if params[:cart_action] == "add"
      #verify params
      photo_print_option = PhotoPrintOption.find(params[:photo_print_option_id])
      
      if photo_print_option.present?
        @shopping_cart.add(photo_print_option, photo_print_option.print_option.price)
      end
      
      redirect_to shopping_cart_path
    
    elsif params[:cart_action] == "update_quantity"
      shopping_cart_item = ShoppingCartItem.find(params[:shopping_cart_item_id])
      if Array(0..99).include?(params[:item_quantity].to_i) 
        shopping_cart_item.quantity = params[:item_quantity].to_i
        shopping_cart_item.save
        shopping_cart_item.destroy if shopping_cart_item.quantity == 0
      end
      
      respond_to do |format|
        format.js
      end
    else
      redirect_to shopping_cart_path
    end
    
    
  end
  
  def index
    @shopping_carts = ShoppingCart.order('updated_at desc')
   
  end
  
  def destroy
    @shopping_cart = ShoppingCart.find(params[:id])
    @shopping_cart.destroy
    respond_to do |format|
      format.html { redirect_to shopping_carts_url }
      format.json { head :no_content }
    end
  end
  
  
  
  
end
