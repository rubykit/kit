
Missing table:

```
    create_table :authentications do |t|
      t.timestamps
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :token
      t.text :extra
    end

    add_index :authentications, [:user_id, :provider]
    add_index :authentications, [:uid, :provider]
    add_index :authentications, :provider
```

