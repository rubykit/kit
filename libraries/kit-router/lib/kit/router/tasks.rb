# Methods to add router visualization Rake tasks to projects.
module Kit::Router::Tasks

  # Create a rake task to generate router visualization.
  #
  #   * `:output_dir` - Where to create the assets files.
  #
  #   * `:task_name` - The name of the rake task.
  #     Defaults to 'documentation:generate'.
  #
  def self.create_rake_task_router_generate_graph!(output_dir:, task_name: 'router:generate_graph')
    ::Rake.application.last_description = 'Generate a router graph for the project'
    ::Rake::Task.define_task(task_name => [:environment]) do
      # TODO: replace with Kit::Log
      puts "TASK: generating router graph in `#{ output_dir }`"

      Kit::Router::Services::Cli.generate_alias_graph_assets(
        output_dir: output_dir,
      )
    end
  end

end
