require 'spec_helper'
require 'yaml'

describe StripeTransaction do
  describe '#from_stripe_charge' do
    before :each do
      @charge = YAML::load_file('spec/support/fixtures/success_charge.yml')
    end
    subject {StripeTransaction.from_stripe_charge(@charge)}
    it {should have_attribute(:stripe_transaction_id).with_value('ch_03oC2qDAUH6m2A')}
    it {should have_attribute(:amount).with_value(100000)}
    it {should have_attribute(:amount_refunded).with_value(0)}
    it {should have_attribute(:transaction_date).with_value(DateTime.parse("Thu, 26 Jul 2012 02:01:15"))}
    it {should have_attribute(:description).with_value('CloudFunded pledge to walmart')}
    it {should have_attribute(:disputed).with_value(false)}
    it {should have_attribute(:failure_message).with_value(nil)}
    it {should have_attribute(:fee).with_value(2930)}
    it {should have_attribute(:invoice).with_value(nil)}
    it {should have_attribute(:object_type).with_value('charge')}
    it {should have_attribute(:paid).with_value(true)}
    it {should have_attribute(:refunded).with_value(false)}
    
    it {should validate_presence_of(:member)}
    it {should validate_presence_of(:pledge)}
  end
end
