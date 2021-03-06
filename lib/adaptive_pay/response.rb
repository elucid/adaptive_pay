module AdaptivePay
  class Response

    attr_reader :raw

    def initialize(interface, type, response)
      @type = type
      @base_page_url = interface.base_page_url
      @attributes = {}
      @raw = response.body
      parse response
    end

    def success?
      !!@success
    end

    def failure?
      !@success
    end


    def created?
      payment_exec_status == "CREATED"
    end

    def pending?
      payment_exec_status == "PENDING"
    end

    def completed?
      payment_exec_status == "COMPLETED"
    end

    def errors
      read_attribute("error")
    end


    def payment_page_url
      case @type
      when :preapproval
        "#{@base_page_url}/webscr?cmd=_ap-preapproval&preapprovalkey=#{URI.escape(preapproval_key)}"
      when :payment
        "#{@base_page_url}/webscr?cmd=_ap-payment&paykey=#{URI.escape(pay_key)}"
      end
    end

    def read_attribute(name)
      names = name.split('.')
      names, last_name = names[0..-2], names.last
      names.inject(@attributes) {|a,n| a[n] || {}}[last_name]
    end

    def method_missing(name, *args)
      if @attributes.has_key?(name.to_s.camelize(:lower))
        @attributes[name.to_s.camelize(:lower)]
      else
        super
      end
    end

    protected
      def parse(response)
        unless response.code.to_s == "200"
          @success = false
          return
        end

        @attributes = Parser.parse(response.body)

        @success = %w{Success SuccessWithWarning}.include?(read_attribute("responseEnvelope.ack"))
      end

  end
end
