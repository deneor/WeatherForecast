class City < ApplicationRecord
  validates :lat , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 , :allow_nil => true}
  validates :lng, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 , :allow_nil => true}
  validate :validate_for_cooords
  validate :validate_if_usefull_for_api
  validates_numericality_of :city_id, :allow_nil => true
  after_create :search_name_for_city

  KEYS=[['name', 'q'],['zip_code','zip'],['lat','coords'],['lng','coords'],['city_id','id']]
  def weather_info
    info=ApplicationRecord.api_call(key_for_api)
    return :error_from_api unless info.include?('cod') and info['cod']==200
    Weather.new(info['main'].slice('temp', 'temp_min', 'temp_max', 'pressure', 'humidity').merge(visibility: info['visibility'],
                                           wind_speed: info['wind']['speed'],
                                           wind_deg: info['wind']['deg'],
                                           clouds: info['clouds']['all']
    ))
  end

  def weather_descriptions
    return ApplicationRecord.api_call(key_for_api)['weather'].map {|desc| desc['description']}
  end

  def lat_from_api
    ApplicationRecord.api_call(key_for_api)['coord']['lat']
  end
  def lng_from_api
    ApplicationRecord.api_call(key_for_api)['coord']['lon']
  end

  def coords
    "lat=#{lat}&lon=#{lng}"
  end

  def key_for_api
    key=KEYS.detect{|k| k[0]==use_for_api}
    key[1]=='coords' ? coords : "#{key[1]}=#{attributes.detect{|a| a[0]==key[0]}[1]}"
  end


  private

  def validate_for_cooords
    if (lat.blank? or lng.blank?) and !(lat.blank? and lng.blank?)
      errors.add(:coords, "Укажите оба поля коордианат или не указывайте их вообще")
    end
  end

  def validate_if_usefull_for_api
    if !errors.any? and ApplicationRecord.api_call(key_for_api)['cod']=='404'
      errors.add(:name, "Не найдена информация о погоде в городе по таким параметрам")
    end
  end

  def search_name_for_city
    update(name:ApplicationRecord.api_call(key_for_api)['name'])
  end
end
