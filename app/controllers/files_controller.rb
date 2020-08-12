class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_file

  authorize_resource

  def destroy
    @file.destroy
    respond_to do |format|
      format.html { redirect_to target_owner, notice: 'Question file deleted.' }
      format.js
    end
  end

  private

  def target_owner
    if @file.record.is_a? Answer
      return @file.record.question
    else
      return @file.record
    end
  end

  def find_file
    @file = ActiveStorage::Attachment.find(params[:id])
  end

end
