module ActiveAdmin
  # This is the class where all the register blocks are evaluated.
  class ResourceDSL < DSL

    private

    # Member Actions give you the functionality of defining both the
    # action and the route directly from your ActiveAdmin registration
    # block.
    #
    # For example:
    #
    #   ActiveAdmin.register Post do
    #     member_action :comments do
    #       @post = Post.find(params[:id]
    #       @comments = @post.comments
    #     end
    #   end
    #
    # Will create a new controller action comments and will hook it up to
    # the named route (comments_admin_post_path) /admin/posts/:id/comments
    #
    # You can treat everything within the block as a standard Rails controller
    # action.
    #

    def logged_member_action(action_name, options = {}, &block)
      logic = Proc.new do
        Models::Event.create(
          type:    Models::Event::TYPES.admin_log,
          message: "#{current_admin_user.model_log_name} trigerred #{action_name} on #{resource.model_log_name}",
          targets: [resource, current_admin_user],
          data: {
            action: action_name,
          }
        )

        self.instance_eval &block
      end

      action config.member_actions, action_name, options, &logic
    end

  end
end