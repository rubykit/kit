databases = ActiveRecord::Tasks::DatabaseTasks.setup_initial_database_yaml

def alias_task(name:, task_ref:)
  desc task_ref.full_comment if task_ref.full_comment
  task name, *task_ref.arg_names do |_, args|
    # values_at is broken on Rake::TaskArguments
    args = task_ref.arg_names.map { |a| args[a] }
    task_ref.invoke(*args)
  end
end

initial_task = Rake::Task['db:schema:dump']

db_namespace = namespace :db do
  namespace :schema do

    # DUMP ---------------------------------------------------------------------

    # Create per database `db:schema:dump` tasks
    initial_dump_task = Rake::Task['db:schema:dump']

    namespace :dump do
      ActiveRecord::Tasks::DatabaseTasks.for_each(databases) do |spec_name|
        desc "Creates a schema.rb file for database `#{spec_name}` that is portable against any DB supported by Active Record"
        task spec_name => :load_config do
          db_config = ActiveRecord::Base.configurations.configs_for(env_name: Rails.env, spec_name: spec_name)
          ActiveRecord::Base.establish_connection(db_config.config)
          ActiveRecord::Tasks::DatabaseTasks.dump_schema(db_config.config, :ruby, db_config.spec_name)

          db_namespace["schema:dump:#{spec_name}"].reenable
        end
      end
    end

    alias_task(name: 'db:schema:dump:all', task_ref: initial_dump_task)

    # Restore Rails expected behaviour
    alias_task(name: 'db:schema:dump',     task_ref: initial_dump_task)

    # LOAD ---------------------------------------------------------------------

    initial_load_task = Rake::Task['db:schema:load']

    namespace :load do
      ActiveRecord::Tasks::DatabaseTasks.for_each(databases) do |spec_name|
        desc "Loads the schema.rb file for database `#{spec_name}`"
        task spec_name => [:load_config, :check_protected_environments] do
          env_name  = Rails.env
          db_config = ActiveRecord::Base.configurations.configs_for(env_name: env_name, spec_name: spec_name)
          #binding.pry

          ActiveRecord::Tasks::DatabaseTasks.load_schema(db_config.config, ActiveRecord::Base.schema_format, nil, env_name, spec_name)
        end
      end
    end

    alias_task(name: 'db:schema:load:all', task_ref: initial_load_task)

    # Restore Rails expected behaviour
    alias_task(name: 'db:load:dump',     task_ref: initial_load_task)

  end
end


