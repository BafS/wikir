defmodule Wikir.PermissionTest do
  use Wikir.ModelCase

  alias Wikir.Permission

  @valid_attrs %{type: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Permission.changeset(%Permission{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Permission.changeset(%Permission{}, @invalid_attrs)
    refute changeset.valid?
  end
end
