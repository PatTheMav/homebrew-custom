class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/8a/be/c8a70292903d598efdb33cf532c1b680ddd62dabd248f1c5d26555df3dd1/gersemi-0.21.0.tar.gz"
  sha256 "b22808035a5f1bfb7e961a26feb2eb88d66c42d4bd0aab73bad017cf11d85bf2"

  head "https://github.com/BlankSpruce/gersemi.git", branch: "master"

  bottle do
    root_url "https://github.com/PatTheMav/homebrew-custom/releases/download/gersemi-0.15.0_1"
    sha256 cellar: :any,                 arm64_sonoma: "fe13408f6b477a50215a0c26bcba5f79d3bc956bddf1762b16a687040a036f37"
    sha256 cellar: :any,                 ventura:      "5d08c995510065fb1075cf912448b752423ed13ff04400fc10b7ad3dcbff1a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f4780ad9e6764e5cec5a2249be21def4786ca03f09e224fe5fc4cb367135e743"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/af/60/bc7622aefb2aee1c0b4ba23c1446d3e30225c8770b38d7aedbfb65ca9d5a/lark-1.2.2.tar.gz"
    sha256 "ca807d0162cd16cef15a8feecb862d7319e7a09bdb13aef927968e45040fed80"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end
end
