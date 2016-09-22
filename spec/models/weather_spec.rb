require 'rails_helper'

RSpec.describe Weather, type: :model do
  it 'very windly from north' do
    Weather.new({'wind'=>{'deg'=>0}}).wind_direction.should eq('N')
  end
end
