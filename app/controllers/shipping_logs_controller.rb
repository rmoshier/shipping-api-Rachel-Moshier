class ShippingLogsController < ApplicationController
require 'active_shipping'
include ActiveMerchant::Shipping

  def ups_shipping
    # make a method that takes three arguments: weight, orgin and destination
    package = Package.new(100, nil)
    origin = Location.new(      :country => 'US',
                                :state => 'WA',
                                :city => 'Seattle',
                                :zip => '98112')

    destination = Location.new( :country => 'US',
                                :state => 'WA',
                                :city => 'Seattle',
                                :postal_code => '98101')

    ups = UPS.new(:login => ENV["UPS_LOGIN"], :password => ENV["UPS_PASSWORD"], :key => ENV["UPS_KEY"])
    response = ups.find_rates(origin, destination, package)

    @ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    render json: @ups_rates.as_json
  end

  def fedex_shipping
    package = Package.new(100, nil)
    origin = Location.new(      :country => 'US',
    :state => 'WA',
    :city => 'Seattle',
    :zip => '98112')

    destination = Location.new( :country => 'US',
    :state => 'WA',
    :city => 'Seattle',
    :postal_code => '98101')

    fedex = FedEx.new(:login => ENV["FEDEX_LOGIN"], :password => ENV["FEDEX_PASSWORD"], key: ENV["FEDEX_KEY"], account: ENV["FEDEX_ACCOUNT"])
    # tracking_info = fedex.find_tracking_info('tracking-number', :carrier_code => 'fedex_ground') # Ground package
    response = fedex.find_rates(origin, destination, package)

    @fedex_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    render json: @fedex_rates.as_json

  end

end
