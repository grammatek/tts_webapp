class ProcessedFilesController < ApplicationController
  #skip_before_action :verify_authenticity_token
  #protect_from_forgery with: :null_session

  def index
    @processed_files = ProcessedFile.all
  end

  def show
    @processed_file = ProcessedFile.find(params[:id])
  end

  def new
    @processed_files = ProcessedFile.all
    @processed_file = ProcessedFile.new
  end

  def create
    @processed_file = ProcessedFile.new(file_params)

    if @processed_file.save
      trigger_job
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @processed_file = ProcessedFile.find(params[:id])
  end

  def update
    @processed_file = ProcessedFile.find(params[:id])

    if @processed_file.update(file_params)
      redirect_to @processed_file
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @processed_file = ProcessedFile.find(params[:id])
    @processed_file.destroy

    redirect_to root_path, status: :see_other
  end

  # Jobs
  def trigger_job
    FileProcessingJob.perform_later(@processed_file.id)
  end

  private
  def file_params
    params.require(:processed_file).permit(:name, :snippet, :text_type, :text_file)
  end
end
