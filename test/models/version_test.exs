defmodule Wikir.VersionTest do
  use Wikir.ModelCase

  alias Wikir.Version

  @valid_attrs %{content: "some content", date: "2010-04-17", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Version.changeset(%Version{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Version.changeset(%Version{}, @invalid_attrs)
    refute changeset.valid?
  end
end
