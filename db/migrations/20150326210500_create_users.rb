Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      String :username,    :null=>false
      String :password, :null=>false
      String :twitter_access_token
      String :twitter_secret_token
      String :authentication_token
    end
  end

  down do
    drop_table(:users)
  end
end