class ConfigurationItemRelationshipsController < ApplicationController
  before_action :set_configuration_item_relationship, only: %i[ show edit update destroy ]

  # GET /configuration_item_relationships or /configuration_item_relationships.json
  def index
    @configuration_item_relationships = ConfigurationItemRelationship.all
  end

  # GET /configuration_item_relationships/1 or /configuration_item_relationships/1.json
  def show
  end

  # GET /configuration_item_relationships/new
  def new
    @configuration_item_relationship = ConfigurationItemRelationship.new
  end

  # GET /configuration_item_relationships/1/edit
  def edit
  end

  # POST /configuration_item_relationships or /configuration_item_relationships.json
  def create
    @configuration_item_relationship = ConfigurationItemRelationship.new(configuration_item_relationship_params)

    respond_to do |format|
      if @configuration_item_relationship.save
        format.html { redirect_to @configuration_item_relationship, notice: "Configuration item relationship was successfully created." }
        format.json { render :show, status: :created, location: @configuration_item_relationship }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @configuration_item_relationship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /configuration_item_relationships/1 or /configuration_item_relationships/1.json
  def update
    respond_to do |format|
      if @configuration_item_relationship.update(configuration_item_relationship_params)
        format.html { redirect_to @configuration_item_relationship, notice: "Configuration item relationship was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @configuration_item_relationship }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @configuration_item_relationship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /configuration_item_relationships/1 or /configuration_item_relationships/1.json
  def destroy
    @configuration_item_relationship.destroy!

    respond_to do |format|
      format.html { redirect_to configuration_item_relationships_path, notice: "Configuration item relationship was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_configuration_item_relationship
      @configuration_item_relationship = ConfigurationItemRelationship.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def configuration_item_relationship_params
      params.expect(configuration_item_relationship: [ :source_configuration_item_id, :target_configuration_item_id, :relationship_type_id ])
    end
end
