class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/8c/1a/7668c2a2d04401ce45c8863fcf33bd14da1431833b198a39eaea3821074e/gersemi-0.14.0.tar.gz"
  sha256 "d8a9c940a56eb988d8d3eaecb48ee9507b9d40d2f87e1e6e896bd0dcba118fa0"

  head "https://github.com/BlankSpruce/gersemi.git", branch: "master"

  bottle do
    root_url "https://github.com/PatTheMav/homebrew-custom/releases/download/gersemi-0.14.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "920415a9de997bdd646c102b48eb540b347d2fdb449ad82805971539882d4caa"
    sha256 cellar: :any_skip_relocation, ventura:      "bc22c8cfece3637eb30e92fd36c13f3fbc41160b0fc17dee8f934c90c99e56c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1e460e4c0296c9bf8d0de3e61ee316ebfbd269e962edd1e08e07eabc84229591"
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
