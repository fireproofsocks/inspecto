defmodule InspectoTest do
  use ExUnit.Case
  alias Inspecto.FakeEctoSchema

  describe "modules/1" do
    test "returns list" do
      assert [
               Enum,
               Enum.EmptyError,
               Enum.OutOfBoundsError,
               Enumerable,
               Enumerable.Date.Range,
               Enumerable.File.Stream,
               Enumerable.Function,
               Enumerable.GenEvent.Stream,
               Enumerable.HashDict,
               Enumerable.HashSet,
               Enumerable.IO.Stream,
               Enumerable.Jason.OrderedObject,
               Enumerable.List,
               Enumerable.Map,
               Enumerable.MapSet,
               Enumerable.Range,
               Enumerable.Stream
             ] = Inspecto.modules(Enum)
    end
  end

  describe "summarize/2" do
    test "empty list for no modules" do
      assert [] = Inspecto.summarize([])
    end

    test "list of Schema structs for raw format" do
      assert [%Inspecto.Schema{}] = Inspecto.summarize([FakeEctoSchema])
    end

    test "skips invalid modules" do
      assert [%Inspecto.Schema{}] = Inspecto.summarize([FakeEctoSchema, Enum])
    end

    test "html format" do
      assert [FakeEctoSchema]
             |> Inspecto.summarize(format: :html)
             |> String.valid?()
    end

    test "applies proper heading level" do
      assert [FakeEctoSchema]
             |> Inspecto.summarize(format: :html, h: 4) =~ "<h4>"
    end

    test "closes head tag" do
      assert [FakeEctoSchema]
             |> Inspecto.summarize(format: :html, h: 4) =~ "</h4>"
    end
  end
end
