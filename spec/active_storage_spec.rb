require "./spec/fixtures/product"
require "pry"

describe 'ActiveStorages' do
  describe ".count" do
    it "returns count of records" do
      Product.all.first.save
      expect(Product.count).to eq(3)
    end
  end

  describe ".where" do
    subject { Product.where(params).count }

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

    context "when is used chain of methods" do
      subject { Product.where(title: "Product").where(body: "Awesome Product").count }

      it { is_expected.to eq 1 }
    end
  end

  describe "#assign_attributes" do
    let(:product) { Product.new }

    it "changes record's attribute" do
      expect { product.assign_attributes(title: "Product") }.to change { product.title }.from(nil).to("Product")
    end
  end
end
