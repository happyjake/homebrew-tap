class Tmux < Formula
  desc "Terminal multiplexer (built from HEAD for latest fixes)"
  homepage "https://tmux.github.io/"
  url "https://github.com/happyjake/tmux.git", branch: "master"
  version "head"
  license "ISC"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "ncurses"
  depends_on "utf8proc"

  uses_from_macos "bison" => :build

  conflicts_with "tmux", because: "both install a tmux binary"

  def install
    system "sh", "autogen.sh"

    args = %W[
      --enable-sixel
      --sysconfdir=#{etc}
      --enable-utf8proc
    ]

    args << "--with-TERM=screen-256color" if OS.mac? && MacOS.version < :sonoma

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"tmux", "-V"
  end
end
