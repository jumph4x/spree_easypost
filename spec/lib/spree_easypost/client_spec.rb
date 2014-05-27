require 'spec_helper'

module SpreeEasypost
  describe 'Client' do
    it 'should instantiate w/ args' do
      lambda{ Client.new(nil) }.should raise_error(ArgumentError)
    end
  end
end
