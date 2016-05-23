defmodule Wikir.Repo.Migrations.CreateVersion do
  use Ecto.Migration

  def change do
    create table(:versions) do
      add :title, :string
      add :content, :text
      add :date, :date

      timestamps
    end

  end
end
