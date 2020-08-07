module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_voted_resource, only: %i[vote unvote]
  end

  def vote
    @vote = @votable.vote(current_user, params[:rate])

    if @vote && @vote.persisted?
      render_vote_json_response(@vote.rate)
    elsif @vote
      render json: { error: @vote.errors.full_messages.join(', ') }, status: :unprocessable_entity
    else
      render json: { error: 'Can\'t vote' }, status: :unprocessable_entity
    end
  end

  def unvote
    @vote = @votable.unvote(current_user)

    render_vote_json_response(nil)
  end

  private

  def render_vote_json_response(rate)
    render json: { rate: rate, rating: @votable.rating }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def load_voted_resource
    @votable = model_klass.find(params[:id])
  end
end