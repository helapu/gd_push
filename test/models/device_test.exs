defmodule GdPush.DeviceTest do
  use GdPush.ModelCase

  alias GdPush.Device

  @valid_attrs %{extra: "some content", nickname: "some content", platform: "some content", token: "some content", uid: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Device.changeset(%Device{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Device.changeset(%Device{}, @invalid_attrs)
    refute changeset.valid?
  end
end
