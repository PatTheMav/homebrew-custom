class ClangFormatAT12 < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.1/llvm-12.0.1.src.tar.xz"
    sha256 "7d9a8405f557cefc5a21bf5672af73903b64749d9bc3a50322239f56f34ffddf"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.1/clang-12.0.1.src.tar.xz"
      sha256 "6e912133bcf56e9cfe6a346fa7e5c52c2cde3e4e48b7a6cc6fcc7c75047da45f"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    root_url "https://github.com/PatTheMav/homebrew-custom/releases/download/clang-format@12-12.0.1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:      "c456fa917e4343da7392d3019d399ccbe49c0d2a3e48443846a29b9c4e1a9953"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aa2d1157ab4026458f35dfb01e101f9872e8af6e2453d9c2230546e183b7affa"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    if build.head?
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"
    else
      (buildpath/"tools/clang").install resource("clang")
    end

    llvmpath = build.head? ? buildpath/"llvm" : buildpath

    mkdir llvmpath/"build" do
      args = std_cmake_args
      args << "-DLLVM_EXTERNAL_PROJECTS=\"clang\""
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "clang-format"
    end

    bin.install llvmpath/"build/bin/clang-format" => "clang-format-12"
    bin.install llvmpath/"tools/clang/tools/clang-format/git-clang-format" => "git-clang-format-12"
  end

  test do
    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format-12 -style=Google test.c")
  end
end
