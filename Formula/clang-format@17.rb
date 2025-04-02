class ClangFormatAT17 < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.3/llvm-17.0.3.src.tar.xz"
  sha256 "18fa6b5f172ddf5af9b3aedfdb58ba070fd07fc45e7e589c46c350b3cc066bc1"
  license "Apache-2.0"
  revision 1
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/PatTheMav/homebrew-custom/releases/download/clang-format@17-17.0.3_1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "b2da39c81c85f4d8046cedbe879ec21d8c3692159a5ddf248eea8f3aaabce102"
    sha256 cellar: :any_skip_relocation, ventura:      "fcbe154296eca0bb912bc8c90aeb5910c20f4d3eaa148fc67da1f7fbf4108caa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8304ee2add45461f23599717e4318ac971aefba2e18368e57a83aba7c6c3ef9e"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  resource "clang" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.3/clang-17.0.3.src.tar.xz"
    sha256 "605a6a091e9d14721ba00048b7409fb73119a60756c959a19a177c8e057d947c"
  end

  resource "cmake" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.3/cmake-17.0.3.src.tar.xz"
    sha256 "54fc534f0da09088adbaa6c3bfc9899a500153b96e60c2fb9322a7aa37b1027a"
  end

  resource "third-party" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.3/third-party-17.0.3.src.tar.xz"
    sha256 "6e84ff16044d698ff0f24e7445f9f47818e6523913a006a5e1ea79625b429b7b"
  end

  def install
    llvmpath = if build.head?
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"

      buildpath/"llvm"
    else
      (buildpath/"src").install buildpath.children
      (buildpath/"src/tools/clang").install resource("clang")
      (buildpath/"cmake").install resource("cmake")
      (buildpath/"third-party").install resource("third-party")

      buildpath/"src"
    end

    system "cmake", "-G", "Ninja", "-S", llvmpath, "-B", "build",
                    "-DLLVM_EXTERNAL_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    "-DLLVM_INCLUDE_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    git_clang_format = llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    inreplace git_clang_format, /clang-format/, "clang-format-17"

    bin.install "build/bin/clang-format" => "clang-format-17"
    bin.install git_clang_format => "git-clang-format-17"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format-17 -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format-17", 1)
  end
end
