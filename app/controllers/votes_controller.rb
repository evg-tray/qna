class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    if ['Answer', 'Question'].include?(params[:votable_type])
      @votable = params[:votable_type].constantize.find(params[:votable_id])
      if current_user.author_of?(@votable) || current_user.voted_of?(@votable)
        render_error
      else
        @vote = @votable.votes.build
        @vote.user = current_user
        @vote.rating = params[:up] == 'true' ? 1 : -1
        if @vote.save
          render_success(@votable, @vote.id, 'create')
        else
          render_error
        end
      end
    else
      render_error
    end
  end

  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy if current_user.author_of?(@vote)
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
end