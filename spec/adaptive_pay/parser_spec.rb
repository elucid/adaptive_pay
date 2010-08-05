require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdaptivePay::Parser do
  it "should parse simple NVP string" do
    body = "foo=bar&baz=bat"
    AdaptivePay::Parser.parse(body).should == {
      "foo" => "bar",
      "baz" => "bat",
    }
  end

  it "should unescape URI-encoded values" do
    body = "name=O%27Reilly"
    AdaptivePay::Parser.parse(body).should == {
      "name" => "O'Reilly",
    }
  end

  it "should parse .-delimited key as namespace-attribute" do
    body = "namespace.attribute=value"
    AdaptivePay::Parser.parse(body).should == {
      "namespace" => {"attribute" => "value"},
    }
  end

  it "should parse (\d+)-suffixed keys as ordered list items" do
    body = "listitem(0).key=value0&listitem(1).key=value1"
    AdaptivePay::Parser.parse(body).should == {
      "listitem" => [
                     {"key" => "value0"},
                     {"key" => "value1"},
                    ],
    }
  end

  it "should parse combined .-delimited and (\d+)-suffixed keys correctly" do
    body = "namespace.listitem(0).key=value0&namespace.listitem(1).key=value1"
    AdaptivePay::Parser.parse(body).should == {
      "namespace" => {
        "listitem" => [
                       {"key" => "value0"},
                       {"key" => "value1"},
                      ],
      }
    }
  end
end
