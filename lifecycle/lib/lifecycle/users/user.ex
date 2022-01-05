defmodule Lifecycle.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema,
    user_id_field: :name,
    password_hash_methods: {&Pow.Ecto.Schema.Password.pbkdf2_hash/1,
                            &Pow.Ecto.Schema.Password.pbkdf2_verify/2},
    password_min_length: 8,
    password_max_length: 4096

  schema "users" do
    #field :custom_field, :string

    pow_user_fields()

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    pow_changeset(user_or_changeset, attrs)
  end
end
