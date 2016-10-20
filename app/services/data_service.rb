class DataService
  include HTTParty

  def initialize(base_uri)
    @base_uri = base_uri
  end

  def data request_action,query_params
    token = "Token token=\"#{Rails.application.secrets["mystique"]["token"]}\""
    response = self.class.get("#{@base_uri}#{request_action}",{query: query_params , :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json', 'Authorization' => token } } )
  end

end