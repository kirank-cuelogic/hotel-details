class HotelsController < ApplicationController

  def search
    options = { country: params[:hotel][:country], state_province: params[:hotel][:state], city: params[:hotel][:city] }.merge!(tracker:'ABC123',rooms:"rooms[][adults]=2")
    # can move to hotel service
    service = DataService.new(Rails.application.secrets['mystique']['host'])
    response = service.data('/api/v1/hotels/rate_search',options)
    @hotels = []
    if response[:errors].nil? && response.code == 200
      @hotels = HotelService.get_hotels(response['resource']['value']['hotels'])
      respond_to do |format|
        format.html { render 'search'}
      end
    else
      raise Errors::WentWrong
    end 
  end
end