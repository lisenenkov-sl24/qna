class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_file

  def destroy
    unless current_user.author_of? @file.record
      respond_to do |format|
        notice = "#{@file.record.class} file can\'t be deleted."
        format.html { redirect_to target_owner, notice: notice }
        format.js { render status: 403, js: "alert('#{helpers.j(notice)}')" }
      end
      return
    end

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
