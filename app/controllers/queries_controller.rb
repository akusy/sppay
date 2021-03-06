class QueriesController < ApplicationController
  respond_to :html
  def index
  end

  def create
    @query = Query.new(query_params)
    if @query.save 
      respond_with @query
    else
      flash[:alert] = @query.errors.full_messages.join('. ')
      redirect_to root_path
    end
  end

  def show
    query = Query.find_by_id params[:id]
    if query && response = read_from_cache(query.id)
      @response = ResponseDecorator.new(response)
      respond_with @response
    else
      flash[:alert] = "No valid response, try again"
      redirect_to root_path
    end
  end

  private

  def query_params
    params.require(:query).permit(:page, :uid, :pub0)
  end

  def read_from_cache key
    Rails.cache.read(key, namespace: :sppay)
  end

end
