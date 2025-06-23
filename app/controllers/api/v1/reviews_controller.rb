module Api
  module V1
    class ReviewsController < ApiController
      before_action :authenticate

      # POST /api/v1/reviews
      def create
        # Check if the user is authenticated
        review = current_user.reviews.new(review_params)

        if review.save
          render json: serializer(review)
        else
          render json: errors(review), status: 422
        end
      end

      # DELETE /api/v1/reviews/:id
      def destroy
        # Check if the user is authenticated and owns the review
        review = current_user.reviews.find(params[:id])

        if review.destroy
          head :no_content
        else
          render json: errors(review), status: 422
        end
      end

      private

      # Strong params
      def review_params
        # Ensure the review params are permitted
        params.require(:review).permit(:title, :description, :score, :airline_id)
      end

      # fast_jsonapi serializer
      def serializer(records, options = {})
        # Use the ReviewSerializer to serialize the review records
        ReviewSerializer
          .new(records, options)
          .serialized_json
      end

      def errors(record)
        { errors: record.errors.messages }
      end
    end
  end
end