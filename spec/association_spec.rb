require "./spec/spec_helper"
require "./spec/fixtures/product"
require "./spec/fixtures/sku"

describe "ActiveStorages::Association" do
  let(:product) { Product.find(1) }
  let(:sku1) { Sku.find(1) }
  let(:sku2) { Sku.find(2) }

  describe ".has_many" do
    it "returns belonging records" do
      expect(product.skus).to match_array([sku1, sku2])
    end
  end

  describe ".belongs_to" do
    it "returns primary record" do
      expect(sku1.product).to eq(product)
    end
  end
end
