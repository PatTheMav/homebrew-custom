class VimCustom < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 25 releases on multiples of 25
  url "https://github.com/vim/vim/archive/v9.0.1600.tar.gz"
  sha256 "6c95ac57bcf1e3caf36e304380cec50074705cfd4f104824b01dec3c1727cdce"
  head "https://github.com/vim/vim.git", branch: "master"

  bottle do
    root_url "https://github.com/PatTheMav/homebrew-custom/releases/download/vim-custom-9.0.1600"
    sha256 monterey:     "54a24ce6c57fb039f6f5f3974475c23ae2609f6d2408351c56872b7494095e3a"
    sha256 x86_64_linux: "597cf5bd377f30014dc0f0861261c369c2d20dd1c3fc0bd554b52aa2384d8f27"
  end

  option "with-gettext", "Build vim with National Language Support (translated messages, keymaps)"
  option "with-libsodium", "Build with libsodium for encrypted file support"
  option "with-client-server", "Enable client/server mode"

  depends_on "ncurses"
  depends_on "gettext" => :optional
  depends_on "libsodium" => :optional
  depends_on "lua" => :optional
  depends_on "luajit" => :optional
  depends_on "perl" => :optional
  depends_on "python@3.11" => :optional
  depends_on "ruby" => :optional

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

    opts = []

    opts << "--disable-selinux" if OS.linux?

    if build.with? "python"
      ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"
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
                          "--enable-gui=no",
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
