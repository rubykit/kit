require 'kit/router/tasks'

Kit::Router::Tasks.create_rake_task_router_generate_graph!(
  output_dir: File.expand_path('../docs/dist/router', __dir__),
  #clean_output_dir: true,
)
