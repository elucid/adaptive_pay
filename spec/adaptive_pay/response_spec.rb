require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdaptivePay::Response do

  before :each do
    @iface = mock(:iface, :base_page_url => "https://www.paypal.com")
  end

  it "should parse a successful response" do
    body = "responseEnvelope.timestamp=2009-07-13T12%3A34%3A29.316-07%3A00&responseEnvelope.ack=Success&responseEnvelope.correlationId=d615a365bed61&responseEnvelope.build=DEV&payKey=AP-3TY011106S4428730&paymentExecStatus=CREATED"
    response = AdaptivePay::Response.new @iface, :other, mock(:response, :body => body, :code => "200")
    response.should be_success
    response.read_attribute("responseEnvelope.timestamp").should == "2009-07-13T12:34:29.316-07:00"
    response.read_attribute("responseEnvelope.ack").should == "Success"
    response.read_attribute("responseEnvelope.correlationId").should == "d615a365bed61"
    response.read_attribute("responseEnvelope.build").should == "DEV"
    response.pay_key.should == "AP-3TY011106S4428730"
    response.payment_exec_status.should == "CREATED"
  end

  it "should interpret a completed response as successful" do
    body = "responseEnvelope.ack=Success"
    response = AdaptivePay::Response.new @iface, :other, mock(:response, :body => body, :code => "200")
    response.should be_success
  end

  it "should interpret a http error as a non succesful response" do
    response = AdaptivePay::Response.new @iface, :other, mock(:response, :body => "", :code => "500")
    response.should_not be_success
  end

  it "should interpret a paypal error as a non succesful response" do
    body = "responseEnvelope.ack=Failure"
    response = AdaptivePay::Response.new @iface, :other, mock(:response, :body => body, :code => "200")
    response.should_not be_success
  end

  it "should provide access to raw response" do
    body = "responseEnvelope.ack=Success"
    response = AdaptivePay::Response.new @iface, :other, mock(:response, :body => body, :code => "200")
    response.should respond_to(:raw)
    response.raw.should == body
  end

  it "should return nil for #read_attribute on missing attribute" do
    body = "responseEnvelope.ack=Success"
    response = AdaptivePay::Response.new @iface, :other, mock(:response, :body => body, :code => "200")
    response.read_attribute("foo").should be_nil
  end

  it "should return nil for #read_attribute on missing nested attribute" do
    body = "responseEnvelope.ack=Success"
    response = AdaptivePay::Response.new @iface, :other, mock(:response, :body => body, :code => "200")
    response.read_attribute("foo.bar").should be_nil
  end

  it "should return nil for #errors on successful response" do
    body = "responseEnvelope.ack=Success"
    response = AdaptivePay::Response.new @iface, :other, mock(:response, :body => body, :code => "200")
    response.should respond_to(:errors)
    response.errors.should be_nil
  end

  it "should provide access to response errors on failed resonse" do
    body = "responseEnvelope.ack=Failure&error(0).errorId=569042&error(0).domain=PLATFORM&error(0).severity=Error"
    response = AdaptivePay::Response.new @iface, :other, mock(:response, :body => body, :code => "200")
    response.should respond_to(:errors)
    response.errors.should == [{"errorId" => "569042", "severity" => "Error", "domain" => "PLATFORM"}]
  end

  describe "payment_page_url" do

    it "should build a payment_page_url for approval" do
      body = "responseEnvelope.ack=Success&preapprovalKey=PA-3TY011106S4428730"
      response = AdaptivePay::Response.new @iface, :preapproval, mock(:response, :body => body, :code => "200")
      response.payment_page_url.should == "https://www.paypal.com/webscr?cmd=_ap-preapproval&preapprovalkey=PA-3TY011106S4428730"
    end

    it "should build a payment_page_url for payment" do
      body = "responseEnvelope.ack=Success&payKey=AP-3TY011106S4428730"
      response = AdaptivePay::Response.new @iface, :payment, mock(:response, :body => body, :code => "200")
      response.payment_page_url.should == "https://www.paypal.com/webscr?cmd=_ap-payment&paykey=AP-3TY011106S4428730"
    end

  end

end
