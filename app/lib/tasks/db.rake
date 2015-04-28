namespace :db do
  require "sequel"
  Sequel.extension :migration
  migrations_path = File.join(File.dirname(__FILE__), "..", "..", "db", "migrations")
  
  desc "Prints current schema version"
  task :version do    
    version = if DB.tables.include?(:schema_migrations)
      DB[:schema_migrations].first[:filename]
    end || 0
 
    puts "Schema Version: #{version}"
  end
 
  desc "Perform migration up to latest migration available"
  task :migrate do
    Sequel::Migrator.run(DB, migrations_path)
    Rake::Task['db:version'].execute
  end
    
  desc "Perform rollback to specified target or full rollback as default"
  task :rollback, :target do |t, args|
    args.with_defaults(:target => 0)
 
    Sequel::Migrator.run(DB, migrations_path, :target => args[:target].to_i)
    Rake::Task['db:version'].execute
  end
 
  desc "Perform migration reset (full rollback and migration)"
  task :reset do
    Sequel::Migrator.run(DB, migrations_path, :target => 0)
    Sequel::Migrator.run(DB, migrations_path)
    Rake::Task['db:version'].execute
  end    
end
