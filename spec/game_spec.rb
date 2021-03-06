# frozen_string_literal: true

require 'game'

RSpec.describe Game do
  let(:row) { subject.instance_variable_get(:@f) }
  let(:game) { subject.instance_variable_get(:@players) }
  describe '#take_input' do
    context 'ask user for input' do
      it 'send to #check_input' do
        expect(subject).to receive(:puts).with("Player #{game.current_player} turn")
        expect(subject).to receive(:puts).with('Please, Choose column')
        expect(subject).to receive(:puts).with('[A, B, C, D, E, F, G]')
        expect(subject).to receive(:gets).and_return('a')
        expect(subject).to receive(:check_input).with('a').once
        subject.take_input
      end
    end
  end
  describe '#check_input' do
    context 'is it valid column?' do
      it 'retunrs input when enter a valid column' do
        expect(subject).to receive(:which_column).once
        valid_column = 'f'
        subject.check_input(valid_column)
      end
    end
    context 'when enter invalid input once, then valid input' do
      it 'asks user again, then returns the valid input' do
        invalid_column = 4
        valid_column = 'e'
        expect(subject).to receive(:puts).with('invalid column').once
        expect(subject).to receive(:take_input).once
        expect(subject).to receive(:which_column).once
        subject.check_input(invalid_column)
        subject.check_input(valid_column)
      end
    end
  end
  describe '#assign_input' do
    context 'puts player input in its correct place' do
      it 'will not change anything if the current row is the sixth row' do
        expect(subject).to receive(:next_row).with(row).exactly(6)
        5.times do
          subject.assign_input(row)
        end
        expect { subject.assign_input(row) }.to_not change { game.current_player }
      end
      it 'change the desired cell to the player choise' do
        expect(subject).to receive(:next_row).with(row).once
        subject.assign_input(row)
        expect(row.rows[row.current_row]).to eq(game.current_player)
      end
    end
  end
  describe '#next_row' do
    context "to increase the last played column's row" do
      it 'change current_row by one' do
        expect { subject.next_row(row) }.to change { row.current_row }.by(1)
      end
    end
    context 'current_row never gets bigger than 6 => the rows' do
      before do
        6.times do
          subject.next_row(row)
        end
      end
      it 'ask user to choose another column' do
        expect(subject).to receive(:pretty_print).once
        expect(subject).to receive(:puts).with('This column is full, Please choose another column').once
        expect(subject).to receive(:take_input).once
        subject.next_row(row)
      end
    end
  end
end
