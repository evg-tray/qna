class VotesController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  respond_to :json

  def create
    return render_error unless Vote.types.include?(params[:votable_type])
    @vote = votable.votes.build(vote_params)
    if @vote.save
      render_success(votable, @vote.id, 'create')
    else
      render_error
    end
  end

  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy
    if @vote.destroyed?
      render_success(@vote.votable, @vote.id, 'delete')
    else
      render_error
    end
  end

  private

  def render_success(votable, id, action)
    render json: {
        rating: votable.rating,
        name: votable.class.name.underscore,
        id: votable.id,
        vote_id: id,
        action: action
    }
  end

  def render_error
    render json: { error_text: 'Error to vote.' }, status: :unprocessable_entity
  end

  def votable
    @votable ||= params[:votable_type].constantize.find(params[:votable_id])
  end

  def vote_params
    { user: current_user, rating: params[:up] == 'true' ? 1 : -1 }
  end
end