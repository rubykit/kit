require 'dry-validation'
# frozen_string_literal: true

module Kit::Auth::Controllers::Api::V1
  class AuthorizationTokensController < Kit::Auth::Controllers::Api::ApiV1Controller # :nodoc:

    # List ---------------------------------------------------------------------

    def jsonapi_pagination(collection)
      prev_cursor_data = Kit::Pagination::Cursor.cursor_data_for_element(ordering: PAGE_ORDERING, element: collection.first)
      prev_token       = Kit::Pagination::Cursor.encode_cursor(cursor_data: prev_cursor_data)
      next_cursor_data = Kit::Pagination::Cursor.cursor_data_for_element(ordering: PAGE_ORDERING, element: collection.last)
      next_token       = Kit::Pagination::Cursor.encode_cursor(cursor_data: next_cursor_data)

      params_prev = {}
      if prev_token
        params_prev = { page: { before: prev_token } }
      end

      params_next = {}
      if next_token
        params_next = { page: { after: next_token } }
      end

      page_size = request.params.dig(:page, :size)
      if page_size.to_i > 0
        params_prev[:page] ||= {}
        params_prev[:page][:size] = page_size
        params_next[:page] ||= {}
        params_next[:page][:size] = page_size
      end

      prev_link = api_v1_authorization_tokens_path(params_prev)
      next_link = api_v1_authorization_tokens_path(params_next)

      {
        prev: prev_link,
        next: next_link,
      }
    end

    PAGE_ORDERING = [[:created_at, :desc], [:id, :desc]]

    afore_action :index, list: [
      :require_current_user!,
    ]

    def index
      list = Kit::Auth::Models::Read::OauthAccessToken
        .where(resource_owner_id: current_user.id)

      list = paginate(relation: list, ordering: PAGE_ORDERING)

      render({
        status: :ok,
        jsonapi: list,
        class: {
          :'Kit::Auth::Models::Read::OauthAccessToken' => Kit::Auth::Serializers::AccessToken,
        },
      })
    end

    # Show ---------------------------------------------------------------------

=begin
    afore_action :show, list: [
      :require_current_user!,
      -> { load_resource!(model: Kit::Auth::Models::Read::OauthAccessToken, param: :id) },
      -> { require_belongs_to!(parent: current_user, child: resource) },
    ]
=end

    def show
      render({
        status: :ok,
        jsonapi: resource,
        class: {
          :'Kit::Auth::Models::Read::OauthAccessToken' => Kit::Auth::Serializers::AccessToken,
        },
      })
    end

    # Create -------------------------------------------------------------------

    def create
      attributes = params[:authorization_token][:data][:attributes]

      context = {
        email:             attributes[:uid],
        password:          attributes[:secret],
        request:           request,
        oauth_application: ::Doorkeeper::Application.find_by!(uid: 'api'),
      }

      res, ctx = Kit::Organizer.call({
        ctx: context,
        list: [
          Kit::Auth::Actions::Users::VerifyUserWithPassword,
          Kit::Auth::Actions::Users::CreateUserRequestMetadata,
          Kit::Auth::Actions::Users::GetAuthorizationTokenForUser,
          Kit::Auth::Actions::Users::UpdateUamForAuthorizationToken,
        ],
      })

      if res == :ok
        token = ctx[:oauth_access_token].to_read_record
        status_code = ctx[:oauth_access_token_created] ? 201 : 200
        render({
          status:  status_code,
          jsonapi: token,
          class: {
            :'Kit::Auth::Models::Read::OauthAccessToken' => Kit::Auth::Serializers::AccessToken,
          },
        })
      else
        render({
          jsonapi_errors: ctx,
        })
      end
    end

  end
end