require 'spec_helper'

describe ACH::NextFederalReserveEffectiveDate do
  context '#result' do
    subject { ACH::NextFederalReserveEffectiveDate.new(run_date).result }

    context 'when today and tomorrow are regular weekdays' do
      let(:run_date) { Date.new(2012, 12, 20) }

      it 'returns tomorrow' do
        expect(subject).to eq(Date.new(2012, 12, 21))
      end
    end

    context 'when today is Friday and Monday is not a holiday' do
      let(:run_date) { Date.new(2012, 11, 2) }

      it 'returns the Monday after' do
        expect(subject).to eq(Date.new(2012, 11, 5))
      end
    end

    context 'when today is Friday and Monday is a holiday' do
      let(:run_date) { Date.new(2012, 05, 25) }

      it 'returns the Tuesday after' do
        expect(subject).to eq(Date.new(2012, 5, 29))
      end
    end

    context 'when today is Friday and Monday is an observed holiday' do
      let(:run_date) { Date.new(2016, 12, 23) }

      it 'returns the Tuesday after' do
        expect(subject).to eq(Date.new(2016, 12, 27))
      end
    end

    context 'when today is Thursday and tomorrow is a observed holiday' do
      let(:run_date) { Date.new(2023, 11, 9) }

      it 'returns tomorrow' do
        expect(subject).to eq(Date.new(2023, 11, 10))
      end
    end

    context 'when today is Monday and a holiday' do
      let(:run_date) { Date.new(2012, 5, 28) }

      it 'returns the Wednesday after' do
        expect(subject).to eq(Date.new(2012, 5, 30))
      end
    end

    context 'when today is Monday and not a holiday and tomorrow is a holiday' do
      let(:run_date) { Date.new(2012, 12, 24) }

      it 'returns the Wednesday after' do
        expect(subject).to eq(Date.new(2012, 12, 26))
      end
    end

    context 'when today is Saturday and Monday is not a holiday' do
      let(:run_date) { Date.new(2012, 11, 3) }

      it 'returns the Tuesday after' do
        expect(subject).to eq(Date.new(2012, 11, 6))
      end
    end

    context 'when today is Saturday and Monday is a Holiday' do
      let(:run_date) { Date.new(2012, 5, 26) }

      it 'returns the Wednesday after' do
        expect(subject).to eq(Date.new(2012, 5, 30))
      end
    end

    context 'when today is Thursday and a holiday' do
      let(:run_date) { Date.new(2012, 11, 22) }

      it 'returns the Monday after' do
        expect(subject).to eq(Date.new(2012, 11, 26))
      end
    end
  end
end
