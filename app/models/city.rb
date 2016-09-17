class City < ApplicationRecord


  def weather_info
    info=ApplicationRecord.api_call(name)
    return Weather.new(info['main'].slice(:temp, :temp_min, :temp_max, :pressure, :humidity).merge(visibility: info['visibility'],
                                           wind_speed: info['wind']['speed'],
                                           wind_deg: info['wind']['deg'],
                                           clouds: info['clouds']['all']
    ))
  end

  def weather_descriptions
    return ApplicationRecord.api_call(name)['weather'].map {|desc| desc['description']}
  end

  def lat
    ApplicationRecord.api_call(name)['coord']['lat']
  end
  def lng
    ApplicationRecord.api_call(name)['coord']['lon']
  end
end
