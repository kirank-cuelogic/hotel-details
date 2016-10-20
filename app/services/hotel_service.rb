class HotelService

  def self.get_hotels hotel_list
    hotels = [] 
    hotel_list.try(:each) do |hotel|
      hotels << Hotel.new(hotel_params(hotel['value']))
    end
    hotels
  end

  def self.hotel_params hotel_data
    rate = hotel_data['average_rate'] || "$00.00 USD"
    rates = rate.split(" ")
    { phone: hotel_data['phone'],id: hotel_data['id'], 
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
end