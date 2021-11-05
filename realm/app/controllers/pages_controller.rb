class PagesController < ApplicationController
  def get
    page = Page.find(params[:id])
    render json: page.detailed_view
  rescue StandardError
    render json: { error: 'Page not found.' }, status: :not_found
  end
end
