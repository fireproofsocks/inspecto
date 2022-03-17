defmodule Inspecto.SchemaTest do
  use ExUnit.Case, async: false
  alias Inspecto.FakeEctoSchema
  alias Inspecto.Schema

  describe "inspect/1" do
    test ":invalid_module returned when module is not an Ecto schema" do
      assert {:invalid_module, _} = Schema.inspect(Enum)
    end

    test ":ok" do
      assert {
               :ok,
               %Inspecto.Schema{
                 fields: [
                   %Inspecto.Schema.Field{
                     default: "default_value",
                     name: :a,
                     type: :string
                   },
                   %Inspecto.Schema.Field{
                     default: 0,
                     name: :b,
                     type: :integer
                   },
                   %Inspecto.Schema.Field{
                     default: nil,
                     name: :c,
                     type: :naive_datetime
                   },
                   %Inspecto.Schema.Field{
                     default: %{},
                     name: :d,
                     type: "ARRAY(d_things)"
                   },
                   %Inspecto.Schema.Field{default: nil, name: :id, type: :integer}
                 ],
                 module: Inspecto.FakeEctoSchema,
                 primary_key: [:id],
                 source: "fake_tablename"
               }
             } = Schema.inspect(FakeEctoSchema)
    end
  end
end
