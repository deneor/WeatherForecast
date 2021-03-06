class CitiesController < ApplicationController
  before_action :set_city, only: [:show, :edit, :update, :destroy]
  http_basic_authenticate_with name: Rails.application.secrets.username, password: Rails.application.secrets.password, only: [:edit, :update, :admin, :destroy, :create]
  skip_before_action :verify_authenticity_token, if: :js_request?

  # GET /cities
  # GET /cities.json
  def index
    @cities = City.all
  end

  def admin
    @cities = City.all
    @admin=true
    respond_to do |format|
      format.html { render :index }
    end
  end


  # GET /cities/1
  # GET /cities/1.json
  def show
    @weather=@city.weather_info
    unless @weather==:error_from_api
      @weather_description=@city.weather_descriptions.join(', ')
    else
      flash[:alert]='Нам не удалось получить данные от API. Попробуйте позже.'
    end
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # GET /cities/new
  def new
    @city = City.new
  end

  # GET /cities/1/edit
  def edit
  end

  # POST /cities
  # POST /cities.json
  def create
    @city = City.new(city_params)
    @city.use_for_api=@city.attributes.slice('name', 'city_id', 'lat', 'lng', 'zip_code').to_a.detect { |a| !a[1].blank? }[0]

    respond_to do |format|
      if @city.save
        format.html { redirect_to @city, notice: 'City was successfully created.' }
        format.json { render :show, status: :created, location: @city }
      else
        format.html { render :new }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cities/1
  # PATCH/PUT /cities/1.json
  def update
    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to @city, notice: 'City was successfully updated.' }
        format.json { render :show, status: :ok, location: @city }
      else
        format.html { render :edit }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.json
  def destroy
    @city.destroy
    respond_to do |format|
      format.html { redirect_to cities_url, notice: 'City was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_city
    @city = City.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def city_params
    params.require(:city).permit(:name, :zip_code, :lat, :lng, :city_id)
  end

  def js_request?
    request.format.js?
  end
end
