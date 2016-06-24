defmodule GdPush.BookTest do
  use GdPush.ModelCase

  alias GdPush.Book

  @valid_attrs %{author: "some content", name: "some content", publish_date: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Book.changeset(%Book{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Book.changeset(%Book{}, @invalid_attrs)
    refute changeset.valid?
  end
end
