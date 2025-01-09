defmodule InspectoTest.User do
  @moduledoc false
  use Ecto.Schema

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          username: String.t(),
          display_name: String.t(),
          date_of_birth: Date.t(),
          age: non_neg_integer(),
          created_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @schema_prefix :core
  schema "users" do
    field(:username, :string)
    field(:display_name, :string)
    field(:date_of_birth, :date)
    field(:age, :integer, virtual: true)

    has_many(:posts, InspectoTest.Post, foreign_key: :author_id)
    has_many(:comments, InspectoTest.Comment, foreign_key: :author_id)

    timestamps(inserted_at: :created_at)
  end
end
