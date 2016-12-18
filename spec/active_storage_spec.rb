require "./spec/fixtures/product"
require "pry"

describe 'ActiveStorages' do
  describe ".count" do
    it "returns count of records" do
      expect(Product.count).to eq(3)
    end
  end

  describe ".where" do
    subject { Product.where(params).size }

    context do
      let(:params) { { title: "Product", body: "Awesome Product" } }

      it { is_expected.to eq 1 }
    end

    context do
      let(:params) { { body: "Awesome Product" } }

      it { is_expected.to eq 2 }
    end

    context "when there is no params" do
      let(:params) { {} }

      it { is_expected.to eq 3 }
    end
  end
end
