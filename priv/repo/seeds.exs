# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Wikir.Repo.insert!(%Wikir.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Wikir.Version
alias Wikir.Article

Wikir.Repo.insert!(%Version{title: "Test", content: "Test content"})
Wikir.Repo.insert!(%Version{title: "Truc", content: "# un truc content"})
# Wikir.Repo.insert!(%Version{title: "Test1", content: "Test content", article_id: 1, user_id: 1})

Wikir.Repo.insert!(%Article{})
