require 'mastodon/status'
require 'mastodon/notification'
require 'mastodon/streaming/deleted_status'

module Mastodon
  module Streaming
    class MessageParser
      MESSAGE_TYPES = {
        'update' => Mastodon::Status,
        'notification' => Mastodon::Notification,
        'delete' => Mastodon::Streaming::DeletedStatus,
      }.freeze

      def self.parse(type, data)
        klass = MESSAGE_TYPES[type]
        klass.new(data) if klass
      end
    end
  end
end
