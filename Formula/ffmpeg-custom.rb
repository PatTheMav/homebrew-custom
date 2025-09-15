class FfmpegCustom < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-8.0.tar.xz"
  sha256 "b2751fccb6cc4c77708113cd78b561059b6fa904b24162fa0be2d60273d27b8e"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/FFmpeg/FFmpeg.git", branch: "master"

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/PatTheMav/homebrew-custom/releases/download/ffmpeg-custom-8.0_1"
    sha256 arm64_sequoia: "2808ba142096df3e0f27a7de44f214ea8c1b3935f8fde6326763786d5763ac29"
    sha256 arm64_sonoma:  "a725b94d9aba752450c9512c5ad1ba825253e3137189afde6230a33bd307e1fe"
    sha256 x86_64_linux:  "e9b413f7130bd0f94d8e7e251c7defb13edd07587f4f0617ff841aa52a003fcb"
  end

  option "with-chromaprint", "Enable the Chromaprint audio fingerprinting library"
  option "with-decklink", "Enable DeckLink support"
  option "with-fdk-aac", "Enable the Fraunhofer FDK AAC library"
  option "with-game-music-emu", "Enable Game Music Emu (GME) support"
  option "with-harfbuzz", "Enable harfbuzz libbrary"
  option "with-librsvg", "Enable SVG files as inputs via librsvg"
  option "with-libsoxr", "Enable the soxr resample library"
  option "with-libssh", "Enable SFTP protocol via libssh"
  option "with-tesseract", "Enable the tesseract OCR engine"
  option "with-libvidstab", "Enable vid.stab support for video stabilization"
  option "with-opencore-amr", "Enable Opencore AMR NR/WB audio format"
  option "with-openh264", "Enable OpenH264 library"
  option "with-openjpeg", "Enable JPEG 2000 image format"
  option "with-openssl", "Enable SSL support"
  option "with-rav1e", "Enable Rav1e AV1 encoder"
  option "with-rubberband", "Enable rubberband library"
  option "with-svt-av1", "Enable SVT-AV1 encoder"
  option "with-webp", "Enable using libwebp to encode WEBP images"
  option "with-zeromq", "Enable using libzeromq to receive commands sent through a libzeromq client"
  option "with-zimg", "Enable z.lib zimg library"
  option "with-srt", "Enable SRT library"
  option "with-librist", "Enable rist support"
  option "with-libvmaf", "Enable libvmaf scoring library"
  option "with-libxml2", "Enable libxml2 library"

  # Default in other Homebrew distros, optional here
  option "with-aom", "Enable AOM AV1 video codec"
  option "with-dav1d", "Enable Dav1d AV1 video codec"
  option "with-libass", "Enable ASS/SSA subtitle format"

  depends_on "pkg-config" => :build
  depends_on "lame"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "sdl2"
  depends_on "snappy"
  depends_on "theora"
  depends_on "x264"
  depends_on "x265"
  depends_on "xz"
  depends_on "aom" => :optional
  depends_on "dav1d" => :optional
  depends_on "fdk-aac" => :optional
  depends_on "fontconfig" => :optional
  depends_on "freetype" => :optional
  depends_on "frei0r" => :optional
  depends_on "game-music-emu" => :optional
  depends_on "harfbuzz" => :optional
  depends_on "libass" => :optional
  depends_on "libbluray" => :optional
  depends_on "libbs2b" => :optional
  depends_on "libcaca" => :optional
  depends_on "libgsm" => :optional
  depends_on "libmodplug" => :optional
  depends_on "librist" => :optional
  depends_on "librsvg" => :optional
  depends_on "libsoxr" => :optional
  depends_on "libssh" => :optional
  depends_on "libvidstab" => :optional
  depends_on "libvmaf" => :optional
  depends_on "libxml2" => :optional
  depends_on "opencore-amr" => :optional
  depends_on "openh264" => :optional
  depends_on "openjpeg" => :optional
  depends_on "openssl@1.1" => :optional
  depends_on "rav1e" => :optional
  depends_on "rubberband" => :optional
  depends_on "speex" => :optional
  depends_on "srt" => :optional
  depends_on "svt-av1" => :optional
  depends_on "tesseract" => :optional
  depends_on "two-lame" => :optional
  depends_on "wavpack" => :optional
  depends_on "webp" => :optional
  depends_on "xvid" => :optional
  depends_on "zeromq" => :optional
  depends_on "zimg" => :optional

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "gcc"
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "libxext"
    depends_on "libxv" # because rubberband is compiled with gcc
  end

  on_intel do
    depends_on "nasm" => :build
  end

  conflicts_with "ffmpeg",
    because: "ffmpeg-custom and ffmpeg both install ffmpeg binary"

  fails_with gcc: "5"

  # Fix for QtWebEngine, do not remove
  # https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=270209
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/ffmpeg/-/raw/5670ccd86d3b816f49ebc18cab878125eca2f81f/add-av_stream_get_first_dts-for-chromium.patch"
    sha256 "57e26caced5a1382cb639235f9555fc50e45e7bf8333f7c9ae3d49b3241d3f77"
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pthreads
      --enable-version3
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-ffplay
      --enable-gpl
      --enable-demuxer=dash
      --enable-libmp3lame
      --enable-libopus
      --enable-libsnappy
      --enable-libtheora
      --enable-libvorbis
      --enable-libvpx
      --enable-libx264
      --enable-libx265
      --enable-lzma
      --disable-libjack
      --disable-indev=jack
    ]

    if OS.mac?
      args << "--enable-opencl"
      args << "--enable-videotoolbox"
      args << "--enable-audiotoolbox"
    end

    args << "--enable-neon" if Hardware::CPU.arm?

    args << "--disable-htmlpages"
    args << "--enable-libaom" if build.with? "aom"
    args << "--enable-chromaprint" if build.with? "chromaprint"
    args << "--enable-libharfbuzz" if build.with? "harfbuzz"
    args << "--enable-libdav1d" if build.with? "dav1d"
    args << "--enable-libfdk-aac" if build.with? "fdk-aac"
    args << "--enable-libfontconfig" if build.with? "fontconfig"
    args << "--enable-libfreetype" if build.with? "freetype"
    args << "--enable-frei0r" if build.with? "frei0r"
    args << "--enable-libgme" if build.with? "game-music-emu"
    args << "--enable-libass" if build.with? "libass"
    args << "--enable-libbluray" if build.with? "libbluray"
    args << "--enable-libbs2b" if build.with? "libbs2b"
    args << "--enable-libcaca" if build.with? "libcaca"
    args << "--enable-libgsm" if build.with? "libgsm"
    args << "--enable-libmodplug" if build.with? "libmodplug"
    args << "--enable-librsvg" if build.with? "librsvg"
    args << "--enable-libsoxr" if build.with? "libsoxr"
    args << "--enable-libssh" if build.with? "libssh"
    args << "--enable-libvidstab" if build.with? "libvidstab"
    args << "--enable-libxml2" if build.with? "libxml2"
    args << "--enable-libopenh264" if build.with? "openh264"
    args << "--enable-openssl" if build.with? "openssl"
    args << "--enable-librav1e" if build.with? "rav1e"
    args << "--enable-libspeex" if build.with? "speex"
    args << "--enable-libsrt" if build.with? "srt"
    args << "--enable-librist" if build.with? "librist"
    args << "--enable-libsvtav1" if build.with? "svt-av1"
    args << "--enable-libtwolame" if build.with? "two-lame"
    args << "--enable-libwavpack" if build.with? "wavpack"
    args << "--enable-libwebp" if build.with? "webp"
    args << "--enable-libxvid" if build.with? "xvid"
    args << "--enable-libzmq" if build.with? "zeromq"
    args << "--enable-libzimg" if build.with? "zimg"

    # These librares are GPL-incompatible, and require ffmpeg be built with
    # the "--enable-nonfree" flag, which produces unredistributable libraries
    args << "--enable-nonfree" if build.with?("decklink") || build.with?("fdk-aac") || build.with?("openssl")

    if build.with? "decklink"
      args << "--enable-decklink"
      args << "--extra-cflags=-I#{HOMEBREW_PREFIX}/include"
      args << "--extra-ldflags=-L#{HOMEBREW_PREFIX}/include"
    end

    args << "--enable-version3" if build.with?("opencore-amr") || build.with?("libvmaf")

    if build.with? "opencore-amr"
      args << "--enable-libopencore-amrnb"
      args << "--enable-libopencore-amrwb"
    end

    if build.with? "openjpeg"
      args << "--enable-libopenjpeg"
      args << "--disable-decoder=jpeg2000"
      args << ("--extra-cflags=" + `pkg-config --cflags libopenjp2`.chomp)
    end

    if build.with? "rubberband"
      args << "--enable-librubberband"
      depends_on "libsamplerate" if OS.mac?
    end

    if build.with? "tesseract"
      args << "--enable-libtesseract"
      depends_on "libarchive" if OS.mac?
    end
    args << "--enable-libvmaf" if build.with? "libvmaf"

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install (buildpath/"tools").children.select { |f| f.file? && f.executable? }
    pkgshare.install buildpath/"tools/python"
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_path_exists mp4out
  end
end
