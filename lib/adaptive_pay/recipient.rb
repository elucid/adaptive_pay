module AdaptivePay
  class Recipient

    attr_accessor :email, :amount, :primary, :invoice_id

    def initialize(options={})
      options.each do |k, v|
        send "#{k}=", v
      end
    end

    def primary?
      !!@primary
    end

  end
end
