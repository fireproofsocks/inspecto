defmodule Inspecto.FakeEctoSchema do
  @moduledoc false
  defstruct id: nil, a: "default_value", b: 0, c: nil, d: %{}
  def __schema__(:source), do: "fake_tablename"
  def __schema__(:primary_key), do: [:id]

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
