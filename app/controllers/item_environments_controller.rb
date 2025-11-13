class ItemEnvironmentsController < ApplicationController
  before_action :set_item_environment, only: %i[ show edit update destroy ]

  # GET /item_environments or /item_environments.json
  def index
    @item_environments = ItemEnvironment.all
  end

  # GET /item_environments/1 or /item_environments/1.json
  def show
  end

  # GET /item_environments/new
  def new
    @item_environment = ItemEnvironment.new
  end

  # GET /item_environments/1/edit
  def edit
  end

  # POST /item_environments or /item_environments.json
  def create
    @item_environment = ItemEnvironment.new(item_environment_params)

    respond_to do |format|
      if @item_environment.save
        format.html { redirect_to @item_environment, notice: "Item environment was successfully created." }
        format.json { render :show, status: :created, location: @item_environment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item_environment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /item_environments/1 or /item_environments/1.json
  def update
    respond_to do |format|
      if @item_environment.update(item_environment_params)
        format.html { redirect_to @item_environment, notice: "Item environment was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @item_environment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item_environment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_environments/1 or /item_environments/1.json
  def destroy
    @item_environment.destroy!

    respond_to do |format|
      format.html { redirect_to item_environments_path, notice: "Item environment was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item_environment
      @item_environment = ItemEnvironment.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def item_environment_params
      params.expect(item_environment: [ :name, :description, :active ])
    end
end
