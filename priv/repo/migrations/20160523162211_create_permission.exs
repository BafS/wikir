defmodule Wikir.Repo.Migrations.CreatePermission do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :type, :string

      timestamps
    end

  end
end
