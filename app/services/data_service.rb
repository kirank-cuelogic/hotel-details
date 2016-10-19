class DataService
  include HTTParty

  def initialize(base_uri)
    @base_uri = base_uri
  end

  def data request_action,query_params
    response = self.get("#{@base_uri}#{request_action}",{query: query_params})
  end

end