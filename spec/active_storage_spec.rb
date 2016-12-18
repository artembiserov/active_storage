require "./spec/fixtures/product"
require "pry"

describe 'ActiveStorages' do
  describe ".count" do
    it "returns count of records" do
      expect(Product.count).to eq(1)
    end
  end
end
