defmodule InspectoTest.Post do
  @moduledoc false
  use Ecto.Schema

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          author_id: Ecto.UUID.t(),
          author: InspectoTest.User.t(),
          title: String.t(),
          body: String.t(),
          is_public: boolean(),
          meta: map(),
          created_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @schema_prefix :core
  schema "posts" do
    field(:title, :string)
    field(:body, :string)
    field(:is_public, :boolean)
    field(:meta, :map, source: :metadata)

    # belongs_to will automatically generates the foreign key field in this schema,
    # e.g. author_id unless `define_field: false`
    belongs_to(:author, InspectoTest.User, type: Ecto.UUID)

    # has_many and has_one does NOT generate a field in this schema.
    # You can verbosely indicate the foreign_key used by the related schema
    # and the local field from this schema that it references.
    has_many(:comments, InspectoTest.Comment,
      foreign_key: :post_id,
      references: :id
    )

    timestamps(inserted_at: :created_at)
  end
end
