class Hotel 
  include ActiveModel::Validations

  attr_accessor :phone, :id, :name, :postal_code, :address, :city,:state_province, :country, :star_rating, :images, :amenities,:human_id, :room_rate, :currency, :currency_code, :latitude,:longitude, :rank, :ean_id, :check_in_time, :check_out_time,:description, :distance, :promo, :standard_rate, :display_id, :policy

end