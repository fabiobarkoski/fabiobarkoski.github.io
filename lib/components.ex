defmodule Blog.Components do
  use Phoenix.Component

  def greet(assigns) do
    ~H"""
      <p class="text-red-500">london, {@name}</p>
    """
  end

  def root(assigns) do
    ~H"""
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <title>Blogoski</title>
      <meta name="description" content="Yet another blog about software development" />
      <meta name="author" content="Fabio Barkoski" />
      <meta property="og:type" content="website" />
      <meta property="og:site_name" content="Blogoski" />
      <meta property="og:title" content="Blogoski" />
      <meta property="og:description" content="Yet another blog about software development" />
      <meta property="og:image" content="/assets/img/social-card.png" />
      <meta name="twitter:card" content="summary" />
      <meta name="twitter:image" content="/assets/img/social-card.png" />
      <meta name="twitter:title" content="Blogoski" />
      <meta name="twitter:description" content="Yet another blog about software development" />
      <link phx-track-static rel="stylesheet" href={@css_path} />
      <script defer phx-track-static type="text/javascript" src={@js_path}></script>
    </head>
    <body class="bg-[#e2e8f0] dark:bg-[#24283b] min-h-screen">
      <header>
        <nav class="mx-auto flex max-w-7xl items-center justify-between p-6 lg:px-8" aria-label="Global">
          <div class="flex lg:flex-1">
            <a href="https://blogoski.com/">
              <h1 class="text-2xl font-bold -m-1.5 p-1.5 text-gray-900 hover:text-gray-900/50 dark:text-[#7aa2f7] dark:hover:text-[#7aa2f7]/50">
                Yet another blog
              </h1>
            </a>
            <button id="theme-toggle" onclick="changeTheme()" type="button" class="text-gray-500 dark:text-gray-400 rounded-lg text-sm p-1.5">
              <svg id="theme-toggle-dark-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5 hidden">
                <path fill-rule="evenodd" d="M9.528 1.718a.75.75 0 01.162.819A8.97 8.97 0 009 6a9 9 0 009 9 8.97 8.97 0 003.463-.69.75.75 0 01.981.98 10.503 10.503 0 01-9.694 6.46c-5.799 0-10.5-4.701-10.5-10.5 0-4.368 2.667-8.112 6.46-9.694a.75.75 0 01.818.162z" clip-rule="evenodd" />
              </svg>
              <svg id="theme-toggle-light-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5 hidden">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 3v2.25m6.364.386l-1.591 1.591M21 12h-2.25m-.386 6.364l-1.591-1.591M12 18.75V21m-4.773-4.227l-1.591 1.591M5.25 12H3m4.227-4.773L5.636 5.636M15.75 12a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0z" />
              </svg>
            </button>
          </div>
          <div class="hidden lg:flex lg:flex-1 lg:justify-end">
            <a href="https://github.com/fabiobarkoski" target="_blank" class="-m-1.5 p-1.5">
              <span class="sr-only">Socials</span>
              <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="hover:scale-110 dark:text-gray-300" viewBox="0 0 16 16">
                <path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.012 8.012 0 0 0 16 8c0-4.42-3.58-8-8-8z" />
              </svg>
            </a>
          </div>
        </nav>
      </header>
      <main class="grid min-h-5/6 place-items-center px-6 py-24 sm:py-32 lg:px-8">
        {@content}  
      </main>
      <footer class="flex justify-center pb-4">
        <span class="text-gray-700 dark:text-[#9aa5ce]">
          © 2026
          <a href="https://blogoski.com/" class="underline">blogoski</a>
          - Made with Elixir and TailwindCSS
        </span>
      </footer>
    </body>
    """
  end

  def homepage(assigns) do
    ~H"""
      <div class="text-center">
        <h1 class="mt-4 text-3xl font-bold tracking-tight sm:text-5xl text-gray-900 dark:text-[#7aa2f7]">
          {@blog_title}
        </h1>
        <p class="mt-6 text-base leading-7 text-gray-700 dark:text-[#9aa5ce]">{@blog_desc}</p>
      </div>
      <div class="mx-auto mt-10 grid max-w-2xl grid-cols-1 gap-x-8 gap-y-16 pt-10 sm:mt-16 sm:pt-16 lg:mx-0 lg:max-w-none lg:grid-cols-3">
        <article :for={post <- @posts} class="flex max-w-xl flex-col items-start justify-between">
          <div class="flex items-center gap-x-4 text-xs mb-2">
            <time class="text-gray-700 dark:text-[#9aa5ce]">{post.date}</time>
            <a :for={tag <- post.tags} href={"tags/#{tag.href}.html"} class="relative z-10 rounded-full bg-gray-50 text-black px3 py-1.5 pr-1 pl-1 font-medium hover:bg-[#c0caf5]">
              {tag.name}
            </a>
          </div>
          <div class="group relative hover:bg-gray-400/50 dark:hover:bg-[#565f89]/50 rounded-md px-4 py-4 dark:text-[#9aa5ce] h-32 w-64">
            <h3 class="mt-3 text-lg font-semibold leading-6 text-900 group-hover:text-gray-900/50 dark:text-[#bb9af7] dark:group-hover:text-[#a9b1d6]/50">
              <a href={"posts/#{post.href}.html"}>
                <span class="absolute inset-0"></span>
                {post.title}
              </a>
            </h3>
            <p class="mt-5 line-clamp-3 text-sm leading-6i"><p>{post.desc}</p></p>
          </div>
        </article>
      </div>
    """
  end

  def tags(assigns) do
    ~H"""
      <div class="text-center">
        <h1 class="mt-4 text-3xl font-bold tracking-tight sm:text-5xl text-gray-900 dark:text-[#7aa2f7]">{@tag}</h1>
        <p class="mt-6 text-base leading-7 text-gray-700 dark:text-[#9aa5ce]">{"Articles under #{@tag} tag"}</p>
      </div>
      <ol :for={post <- @posts} role="list" class="pt-10 divide-y divide-gray-500/50 w-64">
        <li class="flex justify-center justify-between gap-x-6 py-5 pr-4 pl-4 mb-2 hover:bg-gray-400/50 dark:hover:bg-[#565f89]/50 rounded-b-md">
            <a href={"posts/#{post.href}.html"}>
            <div class="flex min-w-0 gap-x-4">
              <div class="min-w-0 flex-auto dark:text-[#9aa5ce]">
                <h2 class="text-l font-semibold leading-6 text-center text-gray-900 dark:text-[#bb9af7]">{post.title}</h2>
                <p class="mt-1 truncate text-xs leading-5 text-gray-700"></p><p>{post.desc}</p><p></p>
              </div>
            </div>
            <div class="hidden shrink-0 sm:flex sm:flex-col sm:items-end">
              <p class="mt-1 text-xs leading-5 text-gray-700 dark:text-[#9aa5ce]">{post.date}</p>
            </div>
          </a>
        </li>
      </ol>
    """
  end

  def posts(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-6 lg:px-8">
      <div class="mx-auto max-w-2xl text-center dark:text-[#9aa5ce]">
        <h2 class="text-3xl font-bold tracking-tight sm:text-4xl text-gray-900 dark:text-[#bb9af7]">{@title}</h2>
        <p class="mt-2 text-lg leading-8 text-gray-700 dark:text-[#9aa5ce]">{@desc}</p>
      </div>
      <div class="mt-6 text-gray-600 dark:text-[#2ac3de]">
        <a href="javascript:history.back()">cd ..</a>
      </div>
      <div class="mt-4 text-justify leading-7 text-gray-700 dark:text-[#9aa5ce]">
        {@content}
      </div>
    </div>
    """
  end
end
