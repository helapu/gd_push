defmodule GdPush.BookView do
  use GdPush.Web, :view

  def render("index.json", %{books: books}) do
    %{data: render_many(books, GdPush.BookView, "book.json")}
  end

  def render("show.json", %{book: book}) do
    %{data: render_one(book, GdPush.BookView, "book.json")}
  end

  def render("book.json", %{book: book}) do
    %{id: book.id,
      name: book.name,
      author: book.author,
      publish_date: book.publish_date}
  end
end
