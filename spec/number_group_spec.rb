require 'spec_helper'
require File.join(File.dirname(__FILE__), '../lib', 'number_group')

describe NumberGroup do
  describe "#validation" do
    it "is valid if it has a row length of 9 items" do
      row = NumberGroup.new('| _ 9 _ | _ _ _ | _ 1 3 |')
      expect(row).to be_valid
    end

    it "is invalid if it does not have a length of 9" do
      row = NumberGroup.new('| 9 _ | _ _ _ | _ 1 3 |')
      expect(row).to_not be_valid
    end
  end

  describe "#to_s" do
    it "outputs itself to look like a sudoku row" do
      row = NumberGroup.new('| _ 9 _ | _ _ _ | _ 1 3 |')
      expect(row.to_s).to eql('|   9   |       |   1 3 |')
    end
  end
end
