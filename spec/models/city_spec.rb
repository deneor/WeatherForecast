require 'rails_helper'

RSpec.describe City, type: :model do
  def fakeapi(error=false)
    good_response =  "{\"coord\":{\"lon\":37.62,\"lat\":55.75},\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"\xD0\xBB\xD0\xB5\xD0\xB3\xD0\xBA\xD0\xB8\xD0\xB9 \xD0\xB4\xD0\xBE\xD0\xB6\xD0\xB4\xD1\x8C\",\"icon\":\"10d\"}],\"base\":\"stations\",\"main\":{\"temp\":7.6,\"pressure\":1005,\"humidity\":93,\"temp_min\":7.22,\"temp_max\":7.78},\"wind\":{\"speed\":2.06,\"deg\":145,\"gust\":5.14},\"rain\":{\"3h\":0.375},\"clouds\":{\"all\":92},\"dt\":1474613321,\"sys\":{\"type\":3,\"id\":57233,\"message\":0.004,\"country\":\"RU\",\"sunrise\":1474600665,\"sunset\":1474644267},\"id\":524901,\"name\":\"Moscow\",\"cod\":200}\n"
    bad_response = "{\"cod\":\"404\",\"message\":\"Error: Not found city\"}"
    response = error ? bad_response : good_response
    stub_request(:get, /http:\/\/api.openweathermap.org\/*/).
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'api.openweathermap.org', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => response, :headers => {})
  end

  it "can get weather_info if you have valid name" do
    fakeapi
    expect(City.new(name:'Moscow', use_for_api:'name').weather_info.class).to eq(Weather)
  end
  it "can get weather_info if you have valid non ascii name" do
    fakeapi
    expect(City.new(name:'Москва', use_for_api:'name').weather_info.class).to eq(Weather)
  end
  it "can get weather_info by zip_code" do
    fakeapi
    expect(City.new(zip_code:'119517', use_for_api:'zip_code').weather_info.class).to eq(Weather)
  end
  it "can get weather info by lat,lng" do
    fakeapi
    expect(City.new(lat:55.75, lng:37.62, use_for_api:'lat').weather_info.class).to eq(Weather)
  end
  it "can get weather info by city_id" do
    fakeapi
    expect(City.new(city_id:524901, use_for_api:'city_id').weather_info.class).to eq(Weather)
  end
  it "raise error on wrong city_id" do
    fakeapi(true)
    expect(City.new(city_id:1524901, use_for_api:'city_id').weather_info).to eq(:error_from_api)
  end
  it "update name from api in creation" do
    fakeapi
    city=City.create(zip_code:'119517', use_for_api: 'zip_code')
    city.name.equal? "Moscow"
  end
  it 'raise error if only 1 field of coords exist' do
    fakeapi
    city=City.new(lat:55.53)
    city.validate
    city.errors.include?(:coords)
  end
  it 'does not raise error on non-blank coords fields' do
    fakeapi
    city=City.new(lat:55.53, lng:37, use_for_api:'lat')
    city.validate
    !city.errors.include?(:coords)
  end
  it 'got coords from api in Float' do
    fakeapi
    City.new(name:'Moscow', use_for_api:'name').lat_from_api.is_a?(Float) and
        City.new(name:'Moscow', use_for_api:'name').lng_from_api.is_a?(Float)
  end

  it 'return false on network error' do
    key='q=London'
    uri=URI(URI::encode("http://api.openweathermap.org/data/2.5/weather?#{key}"+
                            "&APPID=#{Rails.application.secrets.openweathermap_appid}&units=metric&lang=RU"))
    Net::HTTP.stub(:get_response).with(uri).and_raise(SocketError)

    expect(ApplicationRecord.api_call(key)).to eq(false)
  end

end
