module AdaptivePay
  module Parser
    # parse PayPal NVP message into nested Hash/Array structure
    # * treats '.' in key as nesting level
    # * treats \d+ key suffix as list index
    # e.g.
    # "namespace.listitem(0).key=value0&namespace.listitem(1).key=value1"
    #   parses to
    # {"namespace" => {"listitem" => [{"key" => "value0"}, {"key" => "value1"}]}
    def self.parse(body)
      params = {}
      body.split('&').each do |kvp|
        key, value = kvp.split(/=/, 2)

        # keys may be nested e.g. responseEnvelope.ack
        keys = key.split('.')
        value = URI.unescape(value)

        # simple (non-nested, non-indexed) key
        if keys.size == 1
          params[keys.first] = value
        else
          keys, last_key = keys[0..-2], keys.last
          keys.inject(params) do |a,e|
            # indexed key e.g. refundInfo(0)
            if m = e.match(/^(.*)\((\d+)\)$/)
              key = m[1]
              index = m[2].to_i
              a[key] ||= []
              a[key][index] ||= {}
              a[key][index]
            # non-indexed key
            else
              a[e] ||= {}
              a[e]
            end
          end[last_key] = value
        end
      end
      params
    end
  end
end
