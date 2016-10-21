class Room
  attr_accessor \
    :name,
    :amenities,
    :images,
    :description,
    :non_refundable,
    :category,
    :provider_data,
    :provider_id,
    :cancellation_policy,
    :tracker,
    :provider_name,
    :booking_id,
    :hotel_id,
    :arrival,
    :departure,
    :room_total,
    :grand_total,
    :average_rate,
    :payment_type,
    :room_type_id,
    :room_provider_data,
    :provider_data,
    :hotel_policies

    def initialize params
      params.each do |key,value|
        instance_variable_set("@#{key}",value)
      end
    end
end