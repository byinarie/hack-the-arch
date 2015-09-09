class SubmissionsController < ApplicationController

	def new
	end

	def create
		correct = false
		points = 0
		solution = params[:submission][:value]
		@problem = Problem.find(params[:submission][:id])

		# If the solution is correct
		if ( solution == @problem.solution )
			correct = true

			# And it has not already been solved
			if ( Submission.find_by(team_id: current_user.team_id,
															correct: true) )
				flash[:warning] = "Your team has already solved this!"
			else
				flash[:success] = @problem.correct_message
				points = @problem.points
			end

		# Or the answer has already been guessed
		elsif ( Submission.find_by(team_id: current_user.team_id,
															 submission: solution) )
			flash[:warning] = "Your team has already guessed that!"
		else
			flash[:danger] = @problem.false_message
		end
		Submission.create(team_id:  current_user.team_id,
 						 					user_id: current_user.id,
 						 					problem_id: @problem.id,
 						 					submission: solution,
 						 					correct: correct,
 						 					points:	points)

		redirect_to @problem
	end

end