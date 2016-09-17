class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.api_call(city_name)
    uri=URI("http://api.openweathermap.org/data/2.5/weather?q=#{city_name}"+
                "&APPID=#{Rails.application.secrets.openweathermap_appid}&units=metric&lang=RU")
    res=Rails.cache.fetch(uri, expires_in: 10.minutes) do
      Net::HTTP.get_response(uri)
    end
    case res
      when Net::HTTPSuccess
        JSON.parse(res.body)
      else
        #Обработка ошибки
        res.value
    end
  end
end
