defmodule Issues.MixProject do
  use Mix.Project

  def project do
    [
      app: :issues,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript(),
      source_url: "https://github.com/iAmmarTahir/issue_checker"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.0.0" },
      {:poison, "~> 3.1"},
      {:ex_doc, "~> 0.19"},
      {:earmark, "~> 1.2.4"}
    ]
  end
  def escript do
    [
      main_module: Issues.CLI
    ]
  end
end
