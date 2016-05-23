defmodule Wikir.Version do
  use Wikir.Web, :model
  use Ecto.Schema

  schema "versions" do
    field :title, :string
    field :content, :string
    field :date, Ecto.Date
    belongs_to :article, Wikir.Article

    timestamps
  end

  @required_fields ~w(title content date)
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
