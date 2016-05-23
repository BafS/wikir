defmodule Wikir.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
      alter table(:users) do
          add :group_id, references(:groups)
      end
  end
end
