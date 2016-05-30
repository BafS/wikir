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

alias Wikir.Repo
alias Wikir.User
alias Wikir.Article
alias Wikir.Version

Repo.insert!(%Article{})
Repo.insert!(%Article{})

Repo.insert!(%User{username: "admin", password: "123"}) # TODO group_id
Repo.insert!(%User{username: "user1", password: "123"})

Repo.insert!(%Version{title: "Test", content: "Test content", article_id: 1})
Repo.insert!(%Version{title: "Main", content: "# Main page", article_id: 2})
Repo.insert!(%Version{title: "Main", content: "# Main page with updated content", article_id: 2})
# Repo.insert!(%Version{title: "Test1", content: "Test content", article_id: 1, user_id: 1})
