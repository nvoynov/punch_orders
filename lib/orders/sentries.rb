# frozen_string_literal: true
require_relative "basics"

# must be Title
MustbeTitle = Sentry.new(:key, "must be String[3..]"
) {|v| v.is_a?(String) && v.size > 2}

# must be Description
MustbeDescription = Sentry.new(:key, "must be String"
) {|v| v.is_a?(String)}

# must be Money BigDecimal bigdecimal/util
MustbeMoney = Sentry.new(:key, "must respond_to?(:to_d)"
) {|v| v.respond_to?(:to_d)}

# must be Timestamp
MustbeTimestamp = Sentry.new(:key, "must be Time"
) {|v| v.is_a?(Time)}

# must be UUID, but it should be removed for entity?
MustbeUUID = Sentry.new(:id, 'must be UUIDv4') {|v|
  v.is_a?(String) && v =~ /\h{8}-(\h{4}-){3}\h{12}/
}

# must be Order_status
MustbeOrderStatus = Sentry.new(:key, "must be new|submitted|accepted|canceled"
) {|v| %w|new submitted accepted canceled|.include?(v) }

# must be Order_articles, it must be array of hashes with keys id: nil, title:, description:, price:, removed_at:
msg = "must be Array<Hash> with (article_id, quantity, price) keys"
MustbeOrderArticles = Sentry.new(:key, msg) {|v|
  req = %w|article_id quantity price|
  v.is_a?(Array) && v.any? && v.all?{|e|
    e.is_a?(Hash) && req - e.keys == []
  }
}
#   req = %w|title price description|
#   opt = %w|id|
#   v.is_a?(Array) && v.all?{|e|
#     # hash && all required presented && only required and optonal
#     e.is_a?(Hash) &&
#     (req - e.keys == []) &&
#     (e.keys - req - opt == [])
#   }
# }

# must be Array
MustbeArray = Sentry.new(:key, "must be Array") {|v| v.is_a?(Array)}

# must be Hash
MustbeHash = Sentry.new(:key, "must be Hash") {|v| v.is_a?(Hash)}

# must be Page_number
MustbePageNumber = Sentry.new(:page_number, "must be Integer >= 0"
) {|v| v.is_a?(Integer) && v >= 0}

# must be Page_size
MustbePageSize = Sentry.new(:page_size, "must be Integer > 0"
) {|v| v.is_a?(Integer) && v > 0}

# must be positive integer
MustbeQuantity = Sentry.new(:quantity, "must be positive Integer"
) {|v| v.is_a?(Integer) && v > 0}
