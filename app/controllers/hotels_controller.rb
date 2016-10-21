require 'custom_errors'
class HotelsController < ApplicationController

  def search
    options = { country: params[:hotel][:country], state_province: params[:hotel][:state], city: params[:hotel][:city] }.merge!(static_params)
    @hotels = []
    response = HotelService.mystic_hotels_search('/api/v1/hotels/rate_search',options)
    if response[:errors].nil? && response.code == 200
      @hotels = HotelService.get_hotels(response['resource']['value']['hotels'])
      respond_to do |format|
        format.html { render 'search'}
      end
    else
      raise Errors::WentWrong
    end 
  end

  def show
    if params[:id].present?
      options = {country: params[:country], state_province: params[:state], city: params[:city] }.merge!(static_params.merge!( arrival:(Time.zone.now + 2.days).strftime('%F'), departure:(Time.zone.now + 3.days).strftime('%F'))) 
      response = HotelService.hotel_search("/api/v1/rate_breakdowns/standard/#{params[:id]}",options)
      if response[:errors].nil? && response.code == 200
        @hotel = HotelService.get_hotels(response['resource']['value']['hotels'])[0]
        @rooms = response['resource']['value']['provider_rates'].nil? ? [] : HotelService.get_rooms(response['resource']['value']['provider_rates'])
        respond_to do |format|
          format.html { render 'show'}
        end
      else
        raise Errors::WentWrong
      end  
    else
      raise Errors::MissingParameters
    end
  end

  def check_availability
    @available = false
    room_type = params[:hotel].delete(:room_type)
    room_type = CGI.unescape({:room_type => room_type}.to_query)
    response = HotelService.check_available("/api/v1/rate_validations",params[:hotel].merge!(static_params).merge!(room_type:room_type))
    if response[:errors].nil? && response.code == 200
      @available = response['resource']['value']['available']
    else
      raise Errors::WentWrong
    end
  end

end