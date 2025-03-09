class MakeCaseInsensitiveColumnsCollation < ActiveRecord::Migration[8.0]
  def change
    # Make username case-sensitive
    execute "ALTER TABLE users MODIFY username VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"

    # Make reward title case-sensitive
    execute "ALTER TABLE rewards MODIFY title VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
  end
end
