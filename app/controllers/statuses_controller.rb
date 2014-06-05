class StatusesController < ApplicationController
before_filter :authenticate_user!, only: [:show, :create, :new, :edit, :update, :destroy]
before_action :set_status, only: [:show, :edit, :update, :destroy]

#rescue_from ActiveModel::MassAssignmentSecurity::Error, with: :render_permission_error


  # GET /statuses
  # GET /statuses.json
  def index
    params[:page] ||= 1
    @statuses = Status.for_user(current_user, params)
  end

  # GET /statuses/1
  # GET /statuses/1.json
  def show
  end

  # GET /statuses/new
  def new
    @status = Status.new
    @status.build_document
  end

  # GET /statuses/1/edit
  def edit
    if !@status.document
      @status.build_document
    end
  end

  # POST /statuses
  # POST /statuses.json
  def create
    @status = current_user.statuses.new(status_params)
    
    respond_to do |format|
      if @status.save
        current_user.create_activity(@status,'created')
        format.html { redirect_to @status, notice: 'Status was successfully created.' }
        format.json { render :show, status: :created, location: @status }
      else
        format.html { render :new }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @status = current_user.statuses.find(params[:id])
    
    if status_params && status_params.has_key?(:user_id)
      status_params.delete(:user_id)
    end

    if status_params.has_key?(:document_attributes) && params[:status][:document_attributes][:remove_attachment] == '1'
      @status.document.attachment = nil
    else
      if @status.document && @status.document.attachment? && status_params.has_key?(:document_attributes)
        status_params.delete(:document_attributes)
      end
    end

    respond_to do |format|
      if @status.update(status_params)
        current_user.create_activity(@status,'updated')
        format.html { redirect_to @status, notice: 'Status was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.json
  def destroy
    @status.destroy
    respond_to do |format|
      format.html { redirect_to statuses_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status = Status.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_params
      params.require(:status).permit(:content, :id, :status, :profile_name, :full_name, :user_id, :first_name, :last_name, document_attributes: document_permitted_attributes)
    end
end
