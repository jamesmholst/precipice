class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy, :show_full_size]
  before_action :massage_gallery_order, only: :update

  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.order_by_gallery
  end
  
  def uncategorized
    @photos = Photo.uncategorized
  end
  
  def show_full_size
    
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(photo_params)

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: 'Photo was successfully created.' }
        format.json { render action: 'show', status: :created, location: @photo }
      else
        format.html { render action: 'new' }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        if URI(request.referrer).path == "/photos/#{@photo.id}/edit" 
          format.html { redirect_to photos_url, notice: 'Photo was successfully updated.' }
        else
          format.html { redirect_to request.referrer, notice: 'Photo was successfully updated.' }
        end
       
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:name, 
                                    :description, 
                                    :gallery_id, 
                                    :active, 
                                    :paypal_identifier, 
                                    :photo_file,
                                    :gallery_order,
                                    :slideshow_flag)
    end
    
    def massage_gallery_order
      if params[:photo][:gallery_order].present?
        # If new position is lower than previous:
        # Subtract 1 from gallery order to ensure it falls ahead of the photo it is meant to replace.
        # If new position is higher than previous:  
        # Leave be to ensure it is lower (base1 index will be higher than base 0)
        # Gallery Controller will handle the re-order of the collection
        if params[:photo][:gallery_order].to_i <= @photo.gallery_order        
          params[:photo][:gallery_order] = params[:photo][:gallery_order].to_i - 1     
        else
          params[:photo][:gallery_order] = params[:photo][:gallery_order].to_i + 1 
        end
      end
    end
    
    
    
    
end
