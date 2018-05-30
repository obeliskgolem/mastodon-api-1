require 'mastodon/rest/utils'
require 'mastodon/status'

module Mastodon
  module REST
    module Statuses
      include Mastodon::REST::Utils

      # @overload create_status(text, in_reply_to_id, media_ids, visibility)
      #   Create new status
      # @param text [String]
      # @param in_reply_to_id [Integer]
      # @param media_ids [Array<Integer>]
      # @param visibility [String]
      # @return [Mastodon::Status]
      # @overload create_status(text, args)
      #   Create new status
      # @param text [String]
      # @param options [Hash]
      # @option options :in_reply_to_id [Integer]
      # @option options :media_ids [Array<Integer>]
      # @option options :visibility [String]
      # @return <Mastodon::Status>
      def create_status(text, *args)
        params = normalize_status_params(*args)
        params[:status] = text
        params['media_ids[]'] ||= params.delete(:media_ids)

        perform_request_with_object(:post, '/api/v1/statuses', params, Mastodon::Status)
      end

      # Added a customized function to enable the creation of spoiler_texted toot
      def create_status_with_spoiler(text, spoiler, *args)
        params = normalize_status_params(*args)
        params[:status] = text
        params['media_ids[]'] ||= params.delete(:media_ids)
        params[:spoiler_text] = spoiler

        perform_request_with_object(:post, '/api/v1/statuses', params, Mastodon::Status)
      end

      # Retrieve status
      # @param id [Integer]
      # @return [Mastodon::Status]
      def status(id)
        perform_request_with_object(:get, "/api/v1/statuses/#{id}", {}, Mastodon::Status)
      end

      # Destroy status
      # @param id [Integer]
      # @return [Boolean]
      def destroy_status(id)
        !perform_request(:delete, "/api/v1/statuses/#{id}").nil?
      end

      # Reblog a status
      # @param id [Integer]
      # @return [Mastodon::Status]
      def reblog(id)
        perform_request_with_object(:post, "/api/v1/statuses/#{id}/reblog", {}, Mastodon::Status)
      end

      # Undo a reblog of a status
      # @param id [Integer]
      # @return [Mastodon::Status]
      def unreblog(id)
        perform_request_with_object(:post, "/api/v1/statuses/#{id}/unreblog", {}, Mastodon::Status)
      end

      # Favourite a status
      # @param id [Integer]
      # @return [Mastodon::Status]
      def favourite(id)
        perform_request_with_object(:post, "/api/v1/statuses/#{id}/favourite", {}, Mastodon::Status)
      end

      # Undo a favourite of a status
      # @param id [Integer]
      # @return [Mastodon::Status]
      def unfavourite(id)
        perform_request_with_object(:post, "/api/v1/statuses/#{id}/unfavourite", {}, Mastodon::Status)
      end

      # Get a list of accounts that reblogged a toot
      # @param id [Integer]
      # @param options [Hash]
      # @return [Mastodon::Collection<Mastodon::Account>]
      def reblogged_by(id, options = {})
        perform_request_with_collection(:get, "/api/v1/statuses/#{id}/reblogged_by", options, Mastodon::Account)
      end

      # Get a list of accounts that favourited a toot
      # @param id [Integer]
      # @param options [Hash]
      # @return [Mastodon::Collection<Mastodon::Account>]
      def favourited_by(id, options = {})
        perform_request_with_collection(:get, "/api/v1/statuses/#{id}/favourited_by", options, Mastodon::Account)
      end

      # Get a list of statuses by a user
      # @param account_id [Integer]
      # @param options [Hash]
      # @option options :max_id [Integer]
      # @option options :since_id [Integer]
      # @option options :limit [Integer]
      # @return [Mastodon::Collection<Mastodon::Status>]
      def statuses(account_id, options = {})
        perform_request_with_collection(:get, "/api/v1/accounts/#{account_id}/statuses", options, Mastodon::Status)
      end

      private

      def normalize_status_params(*args)
        if args.length == 1 && args.first.is_a?(Hash)
          args.shift
        else
          {
            in_reply_to_id: args.shift,
            'media_ids[]' => args.shift,
            visibility: args.shift,
          }
        end
      end
    end
  end
end
