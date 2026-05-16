class FfmpegCustom < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-8.1.1.tar.xz"
  sha256 "b6863adde98898f42602017462871b5f6333e65aec803fdd7a6308639c52edf3"
  license "GPL-3.0-or-later"
  head "https://github.com/FFmpeg/FFmpeg.git", branch: "master"

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/PatTheMav/homebrew-custom/releases/download/ffmpeg-custom-8.1.1"
    sha256 arm64_tahoe:   "9dd5218f920eb7f774e8912aae950b8681f4e1ec6fcfb36df3f15f91a75af44c"
    sha256 arm64_sequoia: "78a9001d0b7bcafcc439a6eeb860104ef8d117ce433c34c3876d48281e7fb49d"
    sha256 arm64_sonoma:  "7a7a91a6556407dae213f8f43da13be175ee4af50c7dab52d4ea8fb0889d32f8"
    sha256 x86_64_linux:  "c68b10dad4e536b31c1f41107b0fa9beefd4f2c9d8b8cfef9432ad583b2f98e0"
  end

  # Default in Homebrew-core, optional here
  option "with-aom", "Enable AOM AV1 video codec"
  option "with-aribb24", "Enable ARIB STD-824 decoder library"
  option "with-dav1d", "Enable Dav1d AV1 video codec"
  option "with-frei0r", "Enable frei0r video effect plugin API support"
  option "with-harfbuzz", "Enable harfbuzz libbrary"
  option "with-jpegxl", "Enable Jpeg-XL support"
  option "with-libass", "Enable ASS/SSA subtitle format"
  option "with-libbluray", "Enable libbluray supoort"
  option "with-libsoxr", "Enable the soxr resample library"
  option "with-libssh", "Enable SFTP protocol via libssh"
  option "with-libvidstab", "Enable vid.stab support for video stabilization"
  option "with-libvmaf", "Enable libvmaf scoring library"
  option "with-libvorbis", "Enable vorbis codec"
  option "with-libvpx", "Enable vpx video codec"
  option "with-opencore-amr", "Enable Opencore AMR NR/WB audio format"
  option "with-openjpeg", "Enable JPEG 2000 image format"
  option "with-rav1e", "Enable Rav1e AV1 encoder"
  option "with-rubberband", "Enable rubberband library"
  option "with-snappy", "Enable snappy codec"
  option "with-speex", "Enable speex codec"
  option "with-srt", "Enable SRT library"
  option "with-svt-av1", "Enable SVT-AV1 encoder"
  option "with-tesseract", "Enable the tesseract OCR engine"
  option "with-theora", "Enable theora codec"
  option "with-webp", "Enable using libwebp to encode WEBP images"
  option "with-xvid", "Enable Xvid codec"
  option "with-zeromq", "Enable using libzeromq to receive commands sent through a libzeromq client"
  option "with-zimg", "Enable z.lib zimg library"

  # Bonus features
  option "with-fdk-aac", "Enable the Fraunhofer FDK AAC library"
  option "with-game-music-emu", "Enable Game Music Emu (GME) support"
  option "with-openh264", "Enable OpenH264 library"
  option "with-twolame", "Enable two-lame MP2 encoder"

  depends_on "pkg-config" => :build

  depends_on "lame"
  depends_on "opus"
  depends_on "sdl2"
  depends_on "x264"
  depends_on "x265"

  depends_on "aom" => :optional
  depends_on "xz" if build.with?("aom") && OS.mac?
  depends_on "aribb24" => :optional
  depends_on "dav1d" => :optional
  depends_on "fdk-aac" => :optional
  depends_on "frei0r" => :optional
  depends_on "game-music-emu" => :optional
  depends_on "harfbuzz" => :optional
  depends_on "jpeg-xl" => :optional
  depends_on "xz" if build.with?("jpeg-xl") && OS.mac?
  depends_on "libass" => :optional
  depends_on "libbluray" => :optional
  depends_on "libogg" => :optional
  depends_on "libsoxr" => :optional
  depends_on "libssh" => :optional
  depends_on "libvidstab" => :optional
  depends_on "libvmaf" => :optional
  depends_on "libvorbis" => :optional
  depends_on "libvpx" => :optional
  depends_on "opencore-amr" => :optional
  depends_on "openh264" => :optional
  depends_on "openjpeg" => :optional
  depends_on "xz" if build.with?("openjpeg") && OS.mac?
  depends_on "rav1e" => :optional
  depends_on "rubberband" => :optional
  depends_on "libsamplerate" if build.with?("rubberband") && OS.mac?
  depends_on "snappy" => :optional
  depends_on "speex" => :optional
  depends_on "srt" => :optional
  depends_on "svt-av1" => :optional
  depends_on "tesseract" => :optional
  depends_on "theora" => :optional
  depends_on "two-lame" => :optional
  depends_on "webp" => :optional
  depends_on "xz" if build.with?("webp") && OS.mac?
  depends_on "xvid" => :optional
  depends_on "zeromq" => :optional
  depends_on "zimg" => :optional

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "alsa-lib"
    depends_on "libxcb"
    depends_on "xz"
    depends_on "zlib-ng-compat"
  end

  if build.with? "libass"
    depends_on "libx11" if OS.mac?
    depends_on "libxcb" if OS.mac?
  end

  if build.with? "tesseract"
    depends_on "libarchive" if OS.mac?
    depends_on "libx11" if OS.mac?
    depends_on "libxcb" if OS.mac?
    depends_on "xz" if OS.mac?
  end

  on_intel do
    depends_on "nasm" => :build
  end

  conflicts_with "ffmpeg",
    because: "ffmpeg-custom and ffmpeg both install ffmpeg binary"

  def install
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.ld64_version.between?("1015.7", "1022.1")

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
      --enable-libmp3lame
      --enable-libopus
      --enable-libx264
      --enable-libx265
    ]

    args += %w[--enable-videotoolbox --enable-audiotoolbox] if OS.mac?
    args << "--enable-neon" if Hardware::CPU.arm?

    args << "--enable-libaom" if build.with? "aom"
    args << "--enable-libaribb24" if build.with? "aribb24"
    args << "--enable-libdav1d" if build.with? "dav1d"
    args << "--enable-frei0r" if build.with? "frei0r"
    args << "--enable-libass" if build.with? "libass"
    args << "--enable-libharfbuzz" if build.with? "harfbuzz"
    args << "--enable-libgme" if build.with? "game-music-emu"
    args << "--enable-libbluray" if build.with? "libbluray"
    args << "--enable-libjxl" if build.with? "jpeg-xl"
    args << "--enable-libopenh264" if build.with? "openh264"
    args << "--enable-librubberband" if build.with? "rubberband"
    args << "--enable-libsoxr" if build.with? "libsoxr"
    args << "--enable-libssh" if build.with? "libssh"
    args << "--enable-libtesseract" if build.with? "tesseract"
    args << "--enable-libvidstab" if build.with? "libvidstab"
    args << "--enable-libvmaf" if build.with? "libvmaf"
    args << "--enable-libvorbis" if build.with? "libvorbis"
    args << "--enable-libvpx" if build.with? "libvpx"
    args << "--enable-librav1e" if build.with? "rav1e"
    args << "--enable-libsnappy" if build.with? "snappy"
    args << "--enable-libspeex" if build.with? "speex"
    args << "--enable-libsrt" if build.with? "srt"
    args << "--enable-libsvtav1" if build.with? "svt-av1"
    args << "--enable-libtwolame" if build.with? "two-lame"
    args << "--enable-libxvid" if build.with? "xvid"
    args << "--enable-libzmq" if build.with? "zeromq"
    args << "--enable-libzimg" if build.with? "zimg"
    args << "--enable-libtheora" if build.with? "theora"
    args << "--enable-libwebp" if build.with? "webp"

    if build.with? "fdk-aac"
      args << "--enable-nonfree"
      args << "--enable-libfdk-aac"
    end

    if build.with? "opencore-amr"
      args << "--enable-libopencore-amrnb"
      args << "--enable-libopencore-amrwb"
    end

    if build.with? "openjpeg"
      args << "--enable-libopenjpeg"
      args << "--disable-decoder=jpeg2000"
      args << ("--extra-cflags=" + `pkg-config --cflags libopenjp2`.chomp)
    end

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install (buildpath/"tools").children.select { |f| f.file? && f.executable? }
    pkgshare.install buildpath/"tools/python"
  end

  test do
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", mp4out
    assert_match(/Duration: 00:00:05\.00,.*Video: h264/m, shell_output("#{bin}/ffprobe -hide_banner #{mp4out} 2>&1"))

    # Re-encode it in HEVC/Matroska
    mkvout = testpath/"video.mkv"
    system bin/"ffmpeg", "-i", mp4out, "-c:v", "hevc", mkvout
    assert_match(/Duration: 00:00:05\.00,.*Video: hevc/m, shell_output("#{bin}/ffprobe -hide_banner #{mkvout} 2>&1"))
  end
end
