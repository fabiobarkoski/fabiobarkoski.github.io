defmodule Mix.Tasks.Gen.Blog do
  @shortdoc "Generate blog"

  import Blog.Components
  use Phoenix.LiveView
  use MDEx, syntax_highlight: [formatter: {:html_inline, theme: "tokyonight_storm"}]
  use Mix.Task

  @tags ["elixir"]
  @posts posts: [
    %{
      title: "Functional programming to improve your python code reliability",
      desc: "How making your code more functional can improve its reliability",
      date: "Mar 22, 2026",
      tags: [
        %{name: "elixir", href: "elixir"},
        %{name: "functional programming", href: "functional-programming"}
      ],
      href: "functional-python"
    }
  ]

  @impl Mix.Task
  def run(_args) do
    File.mkdir_p!("docs/assets/css")
    File.mkdir_p!("docs/assets/js")
    File.copy!("priv/static/assets/css/app.css", "docs/assets/css/app.css")
    File.copy!("priv/static/assets/js/app.js", "docs/assets/js/app.js")
    homepage()
    tags()
    posts()
  end

  defp save_content(content, filename) do
    File.write!(filename, content)
  end

  def post_content(assigns) do
    content = File.read!("posts/functional-python.md")
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
                title: "Functional programming to improve your python code reliability",
                desc: "How making your code more functional can improve its reliability",
                date: "Mar 22, 2026",
                tags: [
                  %{name: "elixir", href: "elixir"},
                  %{name: "functional programming", href: "functional-programming"}
                ],
                href: "functional-python"
            }
          ]
        })
    }

    base(assigns)
    |> MDEx.to_html!()
    |> save_content("docs/index.html")
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
                title: "Functional programming to improve your python code reliability",
                desc: "How making your code more functional can improve its reliability",
                date: "Mar 22, 2026",
                tags: [
                  %{name: "elixir", href: "elixir"},
                  %{name: "functional programming", href: "functional-programming"}
                ],
                href: "functional-python"
            }
          ]
        })
    }

    base(assigns)
    |> MDEx.to_html!()
    |> save_content("docs/tags/elixir.html")
  end

  defp posts do
    assigns = %{
      title: "Welcome to my blog:)",
      desc: "See some of my posts below",
      css_path: "../assets/css/app.css",
      js_path: "../assets/js/app.js",
      content:
        Blog.Components.posts(%{
          title: "Functional programming to improve your python code reliability",
          desc: "How making your code more functional can improve its reliability",
          content: post_content(%{})
        })
    }

    base(assigns)
    |> MDEx.to_html!()
    |> save_content("docs/posts/functional-python.html")
  end

  def base(assigns) do
    ~MD"""
      <.root title={@title} desc={@desc} content={@content} css_path={@css_path} js_path={@js_path}/>
    """HEEX
  end
end
