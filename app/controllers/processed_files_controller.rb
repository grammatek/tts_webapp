class ProcessedFilesController < ApplicationController
  #skip_before_action :verify_authenticity_token
  #protect_from_forgery with: :null_session
  before_action :set_processed_file, only: [:show, :edit, :update, :destroy]

  def index
    @processed_files = ProcessedFile.ordered[0, 10]
  end

  def show
    @processed_file = ProcessedFile.find(params[:id])
  end

  def new
    @processed_file = ProcessedFile.new
    @processed_files = ProcessedFile.ordered[0, 10]
  end

  def create
    @processed_file = ProcessedFile.new(file_params)

    if @processed_file.save
      trigger_job(@processed_file)
      respond_to do |format|
        format.html {redirect_to root_path, notice: "Nýtt skjal sent í talgervingu"}
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @processed_file = ProcessedFile.find(params[:id])
  end

  def update
    if @processed_file.update(quote_params)
      redirect_to root_path, notice: "Uppfærði skjal"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @processed_file.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: "File was successfully destroyed."}
      format.turbo_stream
    end
  end

  # Jobs
  def trigger_job(processed_file)
    begin
      FileProcessingJob.perform_later(processed_file.id)
    rescue
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_processed_file
    @processed_file = ProcessedFile.find(params[:id])
  end

  def file_params
    params.require(:processed_file).permit(:name, :snippet, :text_file, :text_type, :duration_val)
  end
end
