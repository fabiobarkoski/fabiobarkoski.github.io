defmodule Mix.Tasks.Gen.Blog do
  @shortdoc "Generate blog"

  import Blog.Components
  use Phoenix.LiveView
  use MDEx, syntax_highlight: [formatter: {:html_inline, theme: "tokyonight_storm"}]
  use Mix.Task

  @tags ["elixir"]
  @posts posts: [
    %{
      title: "foi",
      desc: "some desc",
      date: "Dec 03, 2010",
      tags: [
        %{name: "elixir", href: "elixir"}
      ],
      href: "my-super-post"
    }
  ]

  @impl Mix.Task
  def run(_args) do
    File.mkdir_p!("output/assets/css")
    File.mkdir_p!("output/assets/js")
    File.copy!("priv/static/assets/css/app.css", "output/assets/css/app.css")
    File.copy!("priv/static/assets/js/app.js", "output/assets/js/app.js")
    homepage()
    tags()
    posts()
  end

  defp save_content(content, filename) do
    File.write!(filename, content)
  end

  def post_content(assigns) do
    content = File.read!("posts/my-super-post.md")
    MDEx.to_heex!(content, assigns: assigns, syntax_highlight: [formatter: {:html_inline, theme: "tokyonight_storm"}])
  end

  defp homepage do
    assigns = %{
      title: "Welcome to my blog:)",
      desc: "See some of my posts below",
      css_path: "assets/css/app.css",
      js_path: "assets/js/app.js",
      content:
        Blog.Components.homepage(%{
          blog_title: "Welcome to my blog:)",
          blog_desc: "See some of my posts below",
          posts: [
            %{
              title: "foi",
              desc: "some desc",
              date: "Dec 03, 2010",
              tags: [
                %{name: "elixir", href: "elixir"}
              ],
              href: "my-super-post"
            }
          ]
        })
    }

    base(assigns)
    |> MDEx.to_html!()
    |> save_content("output/index.html")
  end

  defp tags do
    assigns = %{
      title: "Welcome to my blog:)",
      desc: "See some of my posts below",
      css_path: "../assets/css/app.css",
      js_path: "../assets/js/app.js",
      content:
        Blog.Components.tags(%{
          tag: "elixir",
          posts: [
            %{
              title: "foi",
              desc: "some desc",
              date: "Dec 03, 2010",
              tags: [
                %{name: "elixir", href: "elixir"}
              ],
              href: "my-super-post"
            }
          ]
        })
    }

    base(assigns)
    |> MDEx.to_html!()
    |> save_content("output/tags/elixir.html")
  end

  defp posts do
    assigns = %{
      title: "Welcome to my blog:)",
      desc: "See some of my posts below",
      css_path: "../assets/css/app.css",
      js_path: "../assets/js/app.js",
      content:
        Blog.Components.posts(%{
          title: "foi",
          desc: "some desc",
          content: post_content(%{name: "jop"})
        })
    }

    base(assigns)
    |> MDEx.to_html!()
    |> save_content("output/posts/my-super-post.html")
  end

  def base(assigns) do
    ~MD"""
      <.root title={@title} desc={@desc} content={@content} css_path={@css_path} js_path={@js_path}/>
    """HEEX
  end
end
