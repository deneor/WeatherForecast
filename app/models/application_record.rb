class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.api_call(city_name)
    uri=URI(URI::encode("http://api.openweathermap.org/data/2.5/weather?q=#{city_name}"+
                "&APPID=#{Rails.application.secrets.openweathermap_appid}&units=metric&lang=RU"))
    res=Rails.cache.fetch(city_name, expires_in: 10.minutes) do
      Net::HTTP.get_response(uri)
    end
    case res
      when Net::HTTPSuccess
        JSON.parse(res.body)
      else
        Rails.cache.delete(city_name)
        return
    end
  end
end
