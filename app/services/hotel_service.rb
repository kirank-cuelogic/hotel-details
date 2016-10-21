class HotelService


  def self.mystic_hotels_search action,options
    service = DataService.new(Rails.application.secrets['mystique']['hsp_host'])
    response = service.data(action,options)
  end

  def self.hotel_search action,options
    service = DataService.new(Rails.application.secrets['mystique']['host'])
    response = service.data(action,options)
  end

  def self.check_available action,options
    service = DataService.new(Rails.application.secrets['mystique']['host'])
    response = service.data(action,options)
  end

  def self.get_hotels hotel_list
    hotels = [] 
    hotel_list.try(:each) do |hotel|
      hotels << Hotel.new(hotel_params(hotel['value']))
    end
    hotels
  end

  def self.get_rooms provider_data
    rooms = []
    provider_data.try(:each) do |provider_rate|
      hotel_info = provider_rate['hotel_rates'][0]
      hotel_info['room_type_rates'].try(:each) do |room_info|
       rooms << Room.new(room_params(room_info['room_type'],room_info['room_rates'],room_info['offer'])) 
      end if hotel_info.present?
    end
    rooms
  end

  def self.hotel_params hotel_data
    rate = hotel_data['average_rate'] || "$00.00 USD"
    rates = rate.split(" ")
    { phone: hotel_data['phone'],
      id: hotel_data['id'], 
     name: hotel_data['name'],
     postal_code: hotel_data['postal_code'], 
     address: hotel_data['address'], 
     city: hotel_data['city'],
     state_province: hotel_data['state_province'] , 
     country: hotel_data['country'], 
     star_rating: hotel_data['star_rating'],
     images: hotel_data['images'], 
     amenities: hotel_data['amenities'],
     currency_code: rates.last, 
     latitude: hotel_data['latitude'],
     longitude: hotel_data['longitude'], 
     human_id: hotel_data['human_id'], 
     check_out_time: hotel_data['check_out_time'],
     description: hotel_data['description'],  
     promo: hotel_data['promo'], 
     display_id: hotel_data['display_id'], 
     check_in_time: hotel_data['check_in_time'], 
     standard_rate: hotel_data['standard_rate'],  
     policy: hotel_data['policy'],
     room_rate: rates[0].split(".")[0].scan(/\d+/).first.to_i, 
     currency: rates[0][0] } 
  end

  def self.room_params room_type,room_rates,offer
    trans_params = room_rates['transitions'][0]['params']
    {
      name:room_type['name'],
      amenities:room_type['amenities'] || [],
      images:room_type['images'],
      description:room_type['description'],
      provider_name: trans_params['provider_name'],
      non_refundable:room_rates['value']['non_refundable'],
      category: room_rates['value']['category'],
      hotel_id: trans_params['hotel_id'],
      booking_id: trans_params['booking_id'],
      cancellation_policy:room_rates['value']['cancellation_policy'],
      tracker:trans_params['tracker'],
      arrival: trans_params['arrival'] ,
      departure: trans_params['departure'] ,
      room_total: trans_params['room_total'],
      grand_total: trans_params['grand_total'],
      average_rate: "#{room_rates['value']['currency_symbol']}#{calculate_average(room_rates['value']['nightly_room_rates'])} #{room_rates['value']['currency_code']}" ,
      payment_type: trans_params['payment_type'],
      room_type_id: trans_params['room_type']['room_type_id'],
      room_provider_data: trans_params['room_type']['provider_data'] ,
      provider_data: trans_params['provider_data'],
      hotel_policies: room_type['validate_info'] || []
    }
  end

  def self.calculate_average rates
    total = rates.map {|x| (x['rate'] || '$00.00 USD').scan(/\d+[,.]?\d+/)[0].to_f }.sum
    (total/rates.length).round(2)
  end
end