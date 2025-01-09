defmodule Inspecto.FakeEctoSchema do
  # This isn't a real Ecto schema, but it looks like one...
  # See https://hexdocs.pm/ecto/Ecto.Schema.html#module-reflection
  # for a full list of stuff that a real Ecto schema would know how to do...
  @moduledoc false
  defstruct id: nil, a: "default_value", b: 0, c: nil, d: %{}
  def __schema__(:source), do: "fake_tablename"
  def __schema__(:prefix), do: :my_prefix
  def __schema__(:primary_key), do: [:id]
  def __schema__(:virtual_type, _fieldname), do: nil

  def __changeset__ do
    %{
      id: :integer,
      a: :string,
      b: :integer,
      c: :naive_datetime,
      d: {:embed, %{cardinality: :many, related: :d_things}}
    }
  end
end
