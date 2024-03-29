class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/36/21/c52ce273a0780602b052a339bc889cef7ee2bfe17e8c373ac4ac9d2b3ecb/gersemi-0.12.1.tar.gz"
  sha256 "3801ddccbb13ad755e47519e0acf6cbed63a555bd3210304907d21604435678c"

  head "https://github.com/BlankSpruce/gersemi.git", branch: "master"

  bottle do
    root_url "https://github.com/PatTheMav/homebrew-custom/releases/download/gersemi-0.12.1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "307f1dcc43bb0e391f58fb78d6cf059541d452bf7179b400cbf2ef38688bfe76"
    sha256 cellar: :any_skip_relocation, ventura:      "891c9b0add127ab5c901150090e45c20e9f0be50c3e60ad318b52699c32551fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ce45561156f26e061b3ecb7b602297f4587f2264ac033d7b417dfa7166ee80ff"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "dataclasses" do
    url "https://files.pythonhosted.org/packages/59/e4/2f921edfdf1493bdc07b914cbea43bc334996df4841a34523baf73d1fb4f/dataclasses-0.6.tar.gz"
    sha256 "6988bd2b895eef432d562370bb707d540f32f7360ab13da45340101bc2307d84"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/2c/e1/804b6196b3fbdd0f8ba785fc62837b034782a891d6f663eea2f30ca23cfa/lark-1.1.9.tar.gz"
    sha256 "15fa5236490824c2c4aba0e22d2d6d823575dcaf4cdd1848e34b6ad836240fba"
  end

  def install
    virtualenv_install_with_resources
  end
end
