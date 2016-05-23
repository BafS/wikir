defmodule Wikir.User do
  use Wikir.Web, :model
  use Ecto.Schema

  schema "users" do
    field :username, :string
    field :password, :string
    has_many :versions, Wikir.Version
    belongs_to :group, Wikir.Group
    
    timestamps
  end

  @required_fields ~w(username password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
