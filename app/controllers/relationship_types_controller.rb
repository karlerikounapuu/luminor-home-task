class RelationshipTypesController < ApplicationController
  before_action :set_relationship_type, only: %i[ show edit update destroy ]

  # GET /relationship_types or /relationship_types.json
  def index
    @relationship_types = RelationshipType.all
  end

  # GET /relationship_types/1 or /relationship_types/1.json
  def show
  end

  # GET /relationship_types/new
  def new
    @relationship_type = RelationshipType.new
  end

  # GET /relationship_types/1/edit
  def edit
  end

  # POST /relationship_types or /relationship_types.json
  def create
    @relationship_type = RelationshipType.new(relationship_type_params)

    respond_to do |format|
      if @relationship_type.save
        format.html { redirect_to @relationship_type, notice: "Relationship type was successfully created." }
        format.json { render :show, status: :created, location: @relationship_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @relationship_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /relationship_types/1 or /relationship_types/1.json
  def update
    respond_to do |format|
      if @relationship_type.update(relationship_type_params)
        format.html { redirect_to @relationship_type, notice: "Relationship type was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @relationship_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @relationship_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relationship_types/1 or /relationship_types/1.json
  def destroy
    @relationship_type.destroy!

    respond_to do |format|
      format.html { redirect_to relationship_types_path, notice: "Relationship type was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relationship_type
      @relationship_type = RelationshipType.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def relationship_type_params
      params.expect(relationship_type: [ :name, :description, :active ])
    end
end
