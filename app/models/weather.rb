class Weather < ApplicationRecord
  attr_accessor :temp, :pressure, :humidity, :temp_min, :temp_max, :visibility, :wind_speed, :wind_deg, :clouds
  WIND_DIRECTIONS=[['N', 0, 11.25], ['NNE', 11.25, 33.75], ['NE', 33.75, 56.25],
                   ['ENE', 56.25, 78.75], ['E', 78.75, 101.25], ['ESE', 101.25, 123.75],
                   ['SE', 123.75, 146.25], ['SSE', 146.25, 168.75], ['S', 168.75, 191.25],
                   ['SSW', 191.25, 213.75], ['SW', 213.75, 236.25], ['WSW', 236.25, 258.75],
                   ['W', 258.75, 281.25], ['WNW', 281.25, 303.75], ['NW', 303.75, 326.25],
                   ['NNW', 326.25, 348.75], ['N', 348.75, 360]]

  def initialize(options={})
    super(options['main'])
    @visibility=options['visibility']
    if options['wind']
      @wind_speed=options['wind']['speed']
      @wind_deg=options['wind']['deg']
    end
    if options['clouds']
      @clouds=options['clouds']['all']
    end
  end

  def wind_direction
    WIND_DIRECTIONS.detect { |dir| wind_deg.between? dir[1], dir[2] }[0] if wind_deg
  end
end


