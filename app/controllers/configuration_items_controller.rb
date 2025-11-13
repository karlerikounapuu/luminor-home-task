class ConfigurationItemsController < ApplicationController
  before_action :set_configuration_item, only: %i[ show edit update destroy ]

  # GET /configuration_items or /configuration_items.json
  def index
    @configuration_items = ConfigurationItem.all
  end

  # GET /configuration_items/1 or /configuration_items/1.json
  def show
  end

  # GET /configuration_items/new
  def new
    @configuration_item = ConfigurationItem.new
  end

  # GET /configuration_items/1/edit
  def edit
  end

  # POST /configuration_items or /configuration_items.json
  def create
    @configuration_item = ConfigurationItem.new(configuration_item_params)

    respond_to do |format|
      if @configuration_item.save
        format.html { redirect_to @configuration_item, notice: "Configuration item was successfully created." }
        format.json { render :show, status: :created, location: @configuration_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @configuration_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /configuration_items/1 or /configuration_items/1.json
  def update
    respond_to do |format|
      if @configuration_item.update(configuration_item_params)
        format.html { redirect_to @configuration_item, notice: "Configuration item was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @configuration_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @configuration_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /configuration_items/1 or /configuration_items/1.json
  def destroy
    @configuration_item.destroy!

    respond_to do |format|
      format.html { redirect_to configuration_items_path, notice: "Configuration item was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_configuration_item
      @configuration_item = ConfigurationItem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def configuration_item_params
      params.expect(configuration_item: [ :name, :description, :item_type_id, :item_status_id, :item_environment_id ])
    end
end
