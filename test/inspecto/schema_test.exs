defmodule Inspecto.SchemaTest do
  use ExUnit.Case, async: false
  alias Inspecto.FakeEctoSchema
  alias Inspecto.Schema

  describe "inspect/1" do
    test ":error returned when module is not an Ecto schema" do
      assert {:error, _} = Schema.inspect(Enum)
    end

    test ":ok" do
      expected_fields = [
        %Inspecto.Schema.Field{
          default: nil,
          is_virtual?: false,
          name: :id,
          type: :integer
        },
        %Inspecto.Schema.Field{
          default: nil,
          is_virtual?: false,
          name: :c,
          type: :naive_datetime
        },
        %Inspecto.Schema.Field{
          default: 0,
          is_virtual?: false,
          name: :b,
          type: :integer
        },
        %Inspecto.Schema.Field{
          default: "default_value",
          name: :a,
          type: :string,
          is_virtual?: false
        },
        %Inspecto.Schema.Field{
          default: %{},
          is_virtual?: false,
          name: :d,
          type: "ARRAY(d_things)"
        }
      ]

      assert {
               :ok,
               %Inspecto.Schema{
                 fields: actual_fields,
                 module: Inspecto.FakeEctoSchema,
                 prefix: :my_prefix,
                 primary_key: [:id],
                 source: "fake_tablename"
               }
             } = Schema.inspect(FakeEctoSchema)

      # Avoid failures due to random sort ordering
      assert MapSet.equal?(MapSet.new(actual_fields), MapSet.new(expected_fields))
    end

    test "virtual fields are flagged properly" do
      {:ok, schema} = Schema.inspect(InspectoTest.User)

      Enum.each(schema.fields, fn
        %{name: :age, is_virtual?: is_virtual?} -> assert is_virtual?
        %{name: _other_fields, is_virtual?: is_virtual?} -> refute is_virtual?
      end)
    end
  end
end
