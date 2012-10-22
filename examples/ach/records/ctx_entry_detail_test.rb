require 'rubygems'
require 'ach'
require 'test/unit'

class CtxEntryDetailTest < Test::Unit::TestCase

  def setup
    @entry = ACH::CtxEntryDetail.new
    @entry.transaction_code = ACH::CHECKING_DEBIT
    @entry.routing_number = '023456789'
    @entry.account_number = '123456789'
    @entry.amount = 10000
    @entry.individual_name = "Bob Roberts"
    @entry.originating_dfi_identification = '02345678'
    @entry.individual_id_number = '1'
    @entry.trace_number = 1
  end

  def test_addenda_records?
    @entry = ACH::CtxEntryDetail.new
    assert @entry.addenda_records? == false

    @entry.addenda << ACH::Addendum.new
    assert @entry.addenda_records? == true

  end

  def test_ctx_entry_prints_addenda
    addendum_1 = ACH::Addendum.new
    addendum_1.payment_data = ""
    addendum_1.sequence_number = "1"
    @entry.addenda << addendum_1
    assert @entry.addenda.size == 1

    addendum_2 = ACH::Addendum.new
    addendum_2.payment_data = ""
    addendum_2.sequence_number = "2"
    @entry.addenda << addendum_2
    assert @entry.addenda.size == 2

    # 705 is the beginning of an addendum record
    ach_string = @entry.to_ach
    assert ach_string.scan("705").count == 2

  end

  def test_ctx_correct_fields
    ach_string = @entry.to_ach
    assert ach_string.slice(39, 15) == "1              "
    assert ach_string.slice(58, 16) == "#{@entry.individual_name.upcase}     "
  end

  def test_to_ach_set_addendum_count_and_entry_detail_sequence_number
    #Set a trace number we expect to find in the addendum record
    expected_trace_number = "474"
    @entry.trace_number = expected_trace_number


    addendum_1 = ACH::Addendum.new
    addendum_1.payment_data = ""
    addendum_1.sequence_number = "1"
    @entry.addenda << addendum_1


    ach_string = @entry.to_ach
    # Test addenda record indicator
    assert ach_string.slice(78, 1) == "1"
    # Test number of addenda records
    assert ach_string.slice(54, 4) == "0001"
    # Test for trace number in each addendum record
    assert ach_string.scan(expected_trace_number).count == 2

  end




end