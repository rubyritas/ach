# frozen_string_literal: true

require 'rubygems'
require 'ach'
require 'test/unit'

class CtxEntryDetailTest < Test::Unit::TestCase
  def setup
    @entry = ACH::CtxEntryDetail.new
    @entry.transaction_code = ACH::CHECKING_DEBIT
    @entry.routing_number = '023456789'
    @entry.account_number = '123456789'
    @entry.amount = 10_000
    @entry.individual_name = 'Bob Roberts'
    @entry.originating_dfi_identification = '02345678'
    @entry.individual_id_number = '1'
    @entry.trace_number = 1
  end

  def test_addenda_records?
    @entry = ACH::CtxEntryDetail.new
    expect(@entry).not_to be_addenda_records

    @entry.addenda << ACH::Addendum.new
    expect(@entry).to be_addenda_records
  end

  def test_ctx_entry_prints_addenda
    addendum1 = ACH::Addendum.new
    addendum1.payment_data = ''
    addendum1.sequence_number = '1'
    @entry.addenda << addendum1
    expect(@entry.addenda.size).to eq(1)

    addendum2 = ACH::Addendum.new
    addendum2.payment_data = ''
    addendum2.sequence_number = '2'
    @entry.addenda << addendum2
    expect(@entry.addenda.size).to eq(2)

    # 705 is the beginning of an addendum record
    ach_string = @entry.to_ach
    expect(ach_string.scan('705').count).to eq(2)
  end

  def test_ctx_correct_fields
    ach_string = @entry.to_ach
    expet(ach_string.slice(39, 15)).to eq('1              ')
    expect(ach_string.slice(58, 16))
      .to eq("#{@entry.individual_name.upcase}     ")
  end

  def test_to_ach_set_addendum_count_and_entry_detail_sequence_number
    # Set a trace number we expect to find in the addendum record
    expected_trace_number = '474'
    @entry.trace_number = expected_trace_number

    addendum1 = ACH::Addendum.new
    addendum1.payment_data = ''
    addendum1.sequence_number = '1'
    @entry.addenda << addendum1

    ach_string = @entry.to_ach
    # Test addenda record indicator
    expect(ach_string.slice(78, 1)).to eq('1')
    # Test number of addenda records
    expect(ach_string.slice(54, 4)).to eq('0001')
    # Test for trace number in each addendum record
    expect(ach_string.scan(expected_trace_number).count).to eq(2)
  end
end
