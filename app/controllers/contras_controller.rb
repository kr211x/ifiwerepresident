class ContrasController < ApplicationController
  # GET /contras
  # GET /contras.json
  def index
    @contras = Contra.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contras }
    end
  end

  # GET /contras/1
  # GET /contras/1.json
  def show
    @contra = Contra.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contra }
    end
  end

  # GET /contras/new
  # GET /contras/new.json
  def new
    @contra = Contra.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contra }
    end
  end

  # GET /contras/1/edit
  def edit
    @contra = Contra.find(params[:id])
  end

  # POST /contras
  # POST /contras.json
  def create
    @contra = Contra.new(params[:contra])

    respond_to do |format|
      if @contra.save
        format.html { redirect_to @contra, notice: 'Contra was successfully created.' }
        format.json { render json: @contra, status: :created, location: @contra }
      else
        format.html { render action: "new" }
        format.json { render json: @contra.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contras/1
  # PUT /contras/1.json
  def update
    @contra = Contra.find(params[:id])

    respond_to do |format|
      if @contra.update_attributes(params[:contra])
        format.html { redirect_to @contra, notice: 'Contra was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @contra.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contras/1
  # DELETE /contras/1.json
  def destroy
    @contra = Contra.find(params[:id])
    @contra.destroy

    respond_to do |format|
      format.html { redirect_to contras_url }
      format.json { head :ok }
    end
  end
end
