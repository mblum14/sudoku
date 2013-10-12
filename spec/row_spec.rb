require 'spec_helper'
require File.join(File.dirname(__FILE__), '../lib', 'row')

describe Row do
  context "a row's numbers field" do
    it "is valid if it has a length of 9 items" do
      row = Row.new('| _ 9 _ | _ _ _ | _ 1 3 |')
      expect(row).to be_valid
    end

    it "is invalid if it does not have a length of 9" do
      row = Row.new('| 9 _ | _ _ _ | _ 1 3 |')
      expect(row).to_not be_valid
    end

    it "is invalid if it has duplicate numbers" do
      row = Row.new('| 9 9 _ | _ _ _ | _ 1 3 |')
      expect(row).to_not be_valid
    end

    it "is solved if it has one of each number 1-9" do
      row = Row.new('| 1 2 3 | 4 5 6 | 7 8 9 |')
      expect(row).to be_solved
    end

    it "is not solved if it does not have one of each number 1-9" do
      row = Row.new('| 1 2 3 | 4 5 6 | 7 8 _ |')
      expect(row).to_not be_solved
    end
  end

  describe "#missing_numbers" do
    it "should have 1, 2, and 3 as the reamining numbers" do
      row = Row.new('| _ _ _ | 4 5 6 | 7 8 9 |')
      expect(row.missing_numbers).to eql [1, 2, 3]
    end
  end

  describe "#to_s" do
    it "outputs itself to look like a sudoku row" do
      row = Row.new('| _ 9 _ | _ _ _ | _ 1 3 |')
      expect(row.to_s).to eql('|   9   |       |   1 3 |')
    end
  end
end
