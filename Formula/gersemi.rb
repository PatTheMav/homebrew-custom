class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/e5/15/96b7a15d9f4f3ae161bfbd0865258a7bbb58e0b9d372fbabd127eb4ffea5/gersemi-0.13.2.tar.gz"
  sha256 "0770879e05de2e4ccaa6fcd39f74289232e6b04e7a8a9b96a10dae41c4c175e2"

  head "https://github.com/BlankSpruce/gersemi.git", branch: "master"

  bottle do
    root_url "https://github.com/PatTheMav/homebrew-custom/releases/download/gersemi-0.13.2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "4bb138c8670f0c692d0fe107e7b6da2b8c43ac582ea355b5c2ca9ffb4521ea4e"
    sha256 cellar: :any_skip_relocation, ventura:      "ea6bfb84b9e5945c457039b5a72102a9f20f20b74fe9148b146f43033abfaf78"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "135e02dc14588f2812c16b89937a5266ab5ae5d49f1104d6fb83a43464462957"
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
