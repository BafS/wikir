defmodule Wikir.Repo.Migrations.AddFieldsToVersions do
  use Ecto.Migration

  def change do
      alter table(:versions) do
          add :article_id, references(:articles)
          add :user_id, references(:users)
      end
  end
end
