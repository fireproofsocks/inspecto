defmodule InspectoTest.Comment do
  @moduledoc false
  use Ecto.Schema

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          content: String.t(),
          author_id: Ecto.UUID.t(),
          post_id: Ecto.UUID.t(),
          post: InspectoTest.Post.t(),
          author: InspectoTest.User.t(),
          created_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @schema_prefix :core
  schema "comments" do
    field(:content, :string)

    # belongs_to will automatically generate the foreign key field,
    # e.g. post_id unless `define_field: false`
    belongs_to(:post, InspectoTest.Post, type: Ecto.UUID)
    belongs_to(:author, InspectoTest.User, type: Ecto.UUID)

    timestamps(inserted_at: :created_at)
  end
end
