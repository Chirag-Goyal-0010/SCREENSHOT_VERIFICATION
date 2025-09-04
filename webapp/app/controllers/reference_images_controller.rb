class ReferenceImagesController < ApplicationController
  before_action :set_reference_image, only: %i[ show edit update destroy ]

  # GET /reference_images or /reference_images.json
  def index
    @reference_images = ReferenceImage.all
  end

  # GET /reference_images/1 or /reference_images/1.json
  def show
  end

  # GET /reference_images/new
  def new
    @reference_image = ReferenceImage.new
  end

  # GET /reference_images/1/edit
  def edit
  end

  # POST /reference_images or /reference_images.json
  def create
    @reference_image = ReferenceImage.new(reference_image_params)

    respond_to do |format|
      if @reference_image.save
        format.html { redirect_to @reference_image, notice: "Reference image was successfully created." }
        format.json { render :show, status: :created, location: @reference_image }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reference_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reference_images/1 or /reference_images/1.json
  def update
    respond_to do |format|
      if @reference_image.update(reference_image_params)
        format.html { redirect_to @reference_image, notice: "Reference image was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @reference_image }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reference_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reference_images/1 or /reference_images/1.json
  def destroy
    @reference_image.destroy!

    respond_to do |format|
      format.html { redirect_to reference_images_path, notice: "Reference image was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reference_image
      @reference_image = ReferenceImage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reference_image_params
      params.require(:reference_image).permit(:title, :description, :file)
    end
end
