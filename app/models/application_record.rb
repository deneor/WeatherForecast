class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.api_call(key)
    uri=URI(URI::encode("http://api.openweathermap.org/data/2.5/weather?#{key}"+
                "&APPID=#{Rails.application.secrets.openweathermap_appid}&units=metric&lang=RU"))
    res=Rails.cache.fetch(key, expires_in: 10.minutes) do
      begin
      Net::HTTP.get_response(uri)
      rescue SocketError => details
        logger.info(details)
      end
    end
    case res
      when Net::HTTPSuccess
        JSON.parse(res.body)
      else
        Rails.cache.delete(key)
        return false
    end
  end
end
