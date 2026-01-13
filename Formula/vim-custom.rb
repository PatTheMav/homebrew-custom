class VimCustom < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 25 releases on multiples of 25
  url "https://github.com/vim/vim/archive/refs/tags/v9.1.2050.tar.gz"
  sha256 "d38a2cccdefc8bf11b417442a6a243c686548d1ef38e348d20d04dd6b6585911"
  license "Vim"
  head "https://github.com/vim/vim.git", branch: "master"

  # The Vim repository contains thousands of tags and the `Git` strategy isn't
  # ideal in this context. This is an exceptional situation, so this checks the
  # first 50 tags using the GitHub API (to minimize data transfer).
  livecheck do
    url "https://api.github.com/repos/vim/vim/tags?per_page=50"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :json do |json, regex|
      json.map do |tag|
        match = tag["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
    throttle 50
  end

  bottle do
    root_url "https://github.com/PatTheMav/homebrew-custom/releases/download/vim-custom-9.1.2050"
    sha256 arm64_tahoe:   "22f08ca0f973b53d56aed71b82a1054f9da3f2972e7fe5885727ec50109d2cff"
    sha256 arm64_sequoia: "5f69853a534415bdec5e65e7205a89bbc760ab89dd14c4b9589dce34a1f2ed0f"
    sha256 arm64_sonoma:  "ada233c7196b9d9e5bffa061876b86e7bd94596437a3917a0fd6997dac872a5f"
    sha256 x86_64_linux:  "19d8187a5a31a47fb992c7ae49acc251b20a7c75a13711ba4abd2b7e9d5f1adf"
  end

  option "with-gettext", "Build vim with National Language Support (translated messages, keymaps)"
  option "with-libsodium", "Build with libsodium for encrypted file support"
  option "with-client-server", "Enable client/server mode"

  depends_on "ncurses"
  depends_on "gettext" => :optional
  depends_on "libsodium" => :optional
  depends_on "lua" => :optional
  depends_on "luajit" => :optional
  depends_on "python@3.13" => :optional
  depends_on "ruby" => :optional

  uses_from_macos "perl"

  on_linux do
    depends_on "acl" => :recommended if build.with? "libsodium"

    depends_on "perl" => :optional

    on_arm do
      depends_on "gcc" => :build
      fails_with :gcc do
        version "14"
        cause "Generates illegal instructions when branch protection is enabled"
      end
    end
  end

  conflicts_with "ex-vi",
    because: "vim-custom and ex-vi both install bin/ex and bin/view"

  conflicts_with "macvim",
    because: "vim-custom and macvim both install vi* binaries"

  conflicts_with "vim",
    because: "vim-custom and vim both install vi* binaries"

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")

    # vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete("PYTHONPATH")

    ENV.append_to_cflags "-mllvm -enable-constraint-elimination=0" if DevelopmentTools.clang_build_version == 1600

    opts = []

    opts << "--disable-selinux" if OS.linux?

    if build.with? "python"
      ENV.prepend_path "PATH", Formula["python@3.13"].opt_libexec/"bin"
      opts << "--enable-python3interp" if build.with? "python"
    end

    opts << "--enable-perlinterp" if build.with? "perl"
    opts << "--enable-rubyinterp" if build.with? "ruby"

    opts << "--disable-nls" if build.without? "gettext"

    if build.with?("lua") || build.with?("luajit")
      opts << "--enable-luainterp"

      if build.with? "luajit"
        opts << "--with-luajit"
        opts << "--with-lua-prefix=#{Formula["luajit"].opt_prefix}"
      else
        opts << "--with-lua-prefix=#{Formula["lua"].opt_prefix}"
      end

      if build.with?("lua") && build.with?("luajit")
        onoe <<~EOS
          Vim will not link against both Luajit & Lua simultaneously.
          Proceeding with Lua.
        EOS
        opts -= %w[--with-luajit]
      end
    end

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    # Homebrew will use the first suitable Perl & Ruby in your PATH if you
    # build from source. Please don't attempt to hardcode either.
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--with-compiledby=Homebrew",
                          "--enable-cscope",
                          "--enable-terminal",
                          "--disable-gui",
                          "--without-x",
                          *opts

    system "make"
    # Parallel install could miss some symlinks
    # https://github.com/vim/vim/issues/1031
    ENV.deparallelize
    # If stripping the binaries is enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # https://github.com/vim/vim/issues/114
    system "make", "install", "prefix=#{prefix}", "STRIP=#{which "true"}"
    bin.install_symlink "vim" => "vi"
  end

  test do
    if build.with? "python"
      (testpath/"commands.vim").write <<~EOS
        :python3 import vim; vim.current.buffer[0] = 'hello python3'
        :wq
      EOS
      system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
      assert_equal "hello python3", File.read("test.txt").chomp
    end
    assert_match "+gettext", shell_output("#{bin}/vim --version") if build.with? "gettext"
    assert_match "+sodium", shell_output("#{bin}/vim --version") if build.with? "libsodium"
  end
end
