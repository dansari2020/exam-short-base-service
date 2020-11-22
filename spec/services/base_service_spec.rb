require 'rails_helper'

RSpec.describe BaseService, type: :module do
  let(:simple_success_service) do
    Class.new do
      include BaseService

      def call(name: nil)
        context[:company] = Company.create(name: name)

      rescue ActiveRecord::NotNullViolation => _
        byebug
        context.fail!(errors: "The company name can't be blank!")
      end
    end
  end

  let(:simple_success_account) do
    Class.new do
      include BaseService
      # Allows calling Factory bot (i.e. create :account)
      include FactoryBot::Syntax::Methods

      def call(name = nil, company = nil)
        context[:account] = Account.create(name: name, company: company)
      end
    end
  end

  context "should save when company name is not empty when call" do
    it '#call' do
      result = simple_success_service.call(name: 'Jenfi')
      expect(result.success?).to be_truthy
      expect(result.company.name).to eq('Jenfi')
    end

    it '#call!' do
      result = simple_success_service.call!(name: 'Jenfi B2')
      expect(result.success?).to be_truthy
      expect(result.company.name).to eq('Jenfi B2')
    end

    it '#flash_msg' do
      result = simple_success_service.call!(name: 'Jenfi B2')
      expect(result.success?).to be_truthy
      company_attributes = result.company.attributes
      expect(result.flash_msg(on_success: company_attributes)).to eq(company_attributes)
    end
  end

  context 'raise an error when do not send empty account name' do
    let(:failed_create_account) { simple_success_account.call }

    it '#call!' do
      expect{ simple_success_account.call! }.to raise_error(BaseService::Failure)
    end

    it '#call' do
      expect(failed_create_account.success?).to be_falsey
    end


    it '#flash_msg' do
      expect(failed_create_account.flash_msg(on_success: {})).to eq({:error => "Name can't be blank"})
    end
  end
end
