require 'spec_helper'

module SpreeEasypost
  describe 'Client' do
    let(:order){ create(:order_with_line_items) }
    let(:client){ Client.new order.shipments[0] }

    it 'should instantiate w/ order arg' do
      expect{ Client.new order }.not_to raise_error
    end

    context 'calculating total weight' do
      it 'should be a valid float' do
        client.total_weight.should > 0
      end
    end

    context 'preparing destinations' do
      it 'uses ship_address' do
        client.destination.should == order.ship_address
      end
    end

    context 'when quoting rates' do
      it 'warns if origin address is ambiguous' do
        sl = client.shipment.stock_location
        sl.zipcode = nil
        sl.save

        expect{ client.get_rates }.to raise_error(NoOriginAddressError)
      end

      it 'returns a rate hash' do
        puts client.get_rates.rates.inspect
        puts client.get_rates.messages.inspect
      end
    end
  end
end
