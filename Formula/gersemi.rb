class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/0b/45/3d19f5760811d5f8c5de825d14f844dfd859d84cc114b2bffd1b4f9b257d/gersemi-0.13.1.tar.gz"
  sha256 "104ed4885ee21ae9d8943775b1873b408b79ac3e260713c2cc8bdba46b48495e"

  head "https://github.com/BlankSpruce/gersemi.git", branch: "master"

  bottle do
    root_url "https://github.com/PatTheMav/homebrew-custom/releases/download/gersemi-0.13.1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "003fd590e013413c173962f556a867335f81e9e007ec9c5577fd0c33f50689b4"
    sha256 cellar: :any_skip_relocation, ventura:      "7f0f9e7a3338467ed2cea1f183555bfc3cad9056ee6578c96321804d3672a0cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f247fa6ffee8dd67ea72ad338bae15b77f1ade6438f6015329af2cb0185b5554"
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
