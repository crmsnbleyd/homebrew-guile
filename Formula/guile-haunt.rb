class GuileHaunt < Formula
  desc "A simple, functional, hackable static site generator that gives authors the ability to treat websites as Scheme programs."
  homepage "https://dthompson.us/projects/haunt.html"
  url "https://files.dthompson.us/releases/haunt/haunt-0.3.0.tar.gz"
  sha256 "98babed06be54a066c3ebc94410a91eb7cc48367e94d528131d3ba271499992b"
  license "GPL-3.0-or-later"

  depends_on "guile"

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = share/"guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = lib/"guile/3.0/site-ccache"

    (testpath/"test-haunt.scm").write <<~SCHEME
    SCHEME

    output = shell_output("#{Formula["guile"].bin}/guile --no-auto-compile test-haunt.scm")
    assert_match "<p>Hello <em>World</em>.</p>", output
  end
end
