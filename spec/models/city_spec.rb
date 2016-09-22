require 'rails_helper'

RSpec.describe City, type: :model do
  it "can get weather_info if you have valid name" do
    expect(City.new(name:'Moscow', use_for_api:'name').weather_info.class).to eq(Weather)
  end
  it "can get weather_info if you have valid non ascii name" do
    expect(City.new(name:'Москва', use_for_api:'name').weather_info.class).to eq(Weather)
  end
  it "can get weather_info by zip_code" do
    expect(City.new(zip_code:'119517', use_for_api:'zip_code').weather_info.class).to eq(Weather)
  end
  it "can get weather info by lat,lng" do
    expect(City.new(lat:55.75, lng:37.62, use_for_api:'lat').weather_info.class).to eq(Weather)
  end
  it "can get weather info by city_id" do
    expect(City.new(city_id:524901, use_for_api:'city_id').weather_info.class).to eq(Weather)
  end
  it "raise error on wrong city_id" do
    expect(City.new(city_id:1524901, use_for_api:'city_id').weather_info).to eq(:error_from_api)
  end
  it "update name from api in creation" do
    city=City.create(zip_code:'119517', use_for_api: 'zip_code')
    city.name.equal? "Matveevskoye"
  end
  it 'raise error if only 1 field of coords exist' do
    city=City.new(lat:55.53)
    city.validate
    city.errors.include?(:coords)
  end
  it 'does not raise error on non-blank coords fields' do
    city=City.new(lat:55.53, lng:37, use_for_api:'lat')
    city.validate
    !city.errors.include?(:coords)
  end

  it 'got coords from api in Float' do
    City.new(name:'Moscow', use_for_api:'name').lat_from_api.is_a?(Float) and
        City.new(name:'Moscow', use_for_api:'name').lng_from_api.is_a?(Float)
  end

end
