module SpreeEasypost
  class Client
    attr_accessor :shipment, :shipping_address

    def initialize shipment
      self.shipment = shipment
    end

    def get_rates
      validate
      easy_shipment
    end

    def destination
      shipment.order.ship_address
    end

    def origin
      shipment.stock_location
    end

    def total_weight
      shipment.line_items.sum{|li| li.variant.weight }
    end

    def origin_address_entered?
      (origin.state || origin.state_name) && origin.country && origin.zipcode
    end

    def validate
      raise NoOriginAddressError unless origin_address_entered?
    end

    def easy_destination
      EasyPost::Address.create(
        #:company => 'Simpler Postage Inc',
        :street1 => destination.address1,
        :street2 => destination.address2,
        :city => destination.city,
        :state => destination.country.iso,
        :zip => destination.zipcode
        #:phone => '415-456-7890'
      )
    end

    def easy_origin
      EasyPost::Address.create(
        #:name => '',
        street1: origin.address1,
        city: origin.city,
        state: origin.state_name.presence || origin.state.name,
        zip: origin.zipcode,
        country: origin.country.iso
      )
    end

    def easy_parcel
      EasyPost::Parcel.create(
        :weight => total_weight
        #:length => 18,
        #:height => 9.5,
        #:width => 35.1
      )
    end

    def easy_shipment
      @easy_shipment ||= EasyPost::Shipment.create(
        :to_address => easy_destination,
        :from_address => easy_origin,
        :parcel => easy_parcel
      )
    end
  end
end
