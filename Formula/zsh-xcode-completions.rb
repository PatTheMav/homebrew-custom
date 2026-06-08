class ZshXcodeCompletions < Formula
  desc "Zsh completions for Xcode command-line tools"
  homepage "https://github.com/keith/zsh-xcode-completions/"
  url "https://github.com/keith/zsh-xcode-completions/archive/refs/tags/1.6.0.tar.gz"
  sha256 "e539e706a6651ce54dfb77aa2ba381550a2b2562a2a055659dc66828b10b8189"

  head "https://github.com/keith/zsh-xcode-completions.git", branch: "master"

  bottle do
    root_url "https://github.com/PatTheMav/homebrew-custom/releases/download/zsh-xcode-completions-1.6.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a328a2f68cb85cd6d0a6b7498d37b479683eb899595c2e3f5d3cf4bdc6935b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a45e2fb1c73b0d478763873160bf5276761b6f8077e1f75f825f1f34867d932b"
  end

  depends_on "jq"
  depends_on :macos

  def install
    zsh_completion.install Dir["src/_*"]
  end

  def caveats
    <<~EOS
      To activate these completions, add the following to your .zshrc:

        fpath=(#{HOMEBREW_PREFIX}/share/zsh/site-functions $fpath)

      You may also need to force rebuild `zcompdump`:

        rm -f ~/.zcompdump; compinit

      Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
      to load these completions, you may need to run this:

        chmod go-w #{HOMEBREW_PREFIX}/share
    EOS
  end

  test do
    (testpath/".zshrc").write <<~EOS
      fpath=(#{HOMEBREW_PREFIX}/share/zsh/site-functions $fpath)
      autoload -U compinit
      compinit
    EOS
    system "/bin/zsh", "--login", "-i", "-c", "which _xcodebuild"
  end
end
