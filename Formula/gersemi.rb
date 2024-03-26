class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/44/22/86fecb254714c5b8e49a2c9cbcd86385175e0c7963c116592c07fc03b1c1/gersemi-0.12.0.tar.gz"
  sha256 "c0446a7190061dbcd4990e1d4a958124660972801559ca0e61316a5a805ff35e"

  head "https://github.com/BlankSpruce/gersemi.git", branch: "master"

  bottle do
    root_url "https://github.com/PatTheMav/homebrew-custom/releases/download/gersemi-0.11.1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "8fda72818b612615fb33f0cb2672bdfa9dee6ca931c951717b1e9e4eb711e93c"
    sha256 cellar: :any_skip_relocation, ventura:      "f33f0ea5def9520e723c6f49cd043d0031f2de0b2d42fe0cc9822d29fdb864f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8670a46de266a6b353cd600ca19213a4d46b4f94ffb03c114f801cc65f9c00e8"
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
