class GuileCommonmark < Formula
  desc "Guile library for parsing CommonMark"
  homepage "https://github.com/OrangeShark/guile-commonmark"
  url "https://github.com/OrangeShark/guile-commonmark/releases/download/v0.1.2/guile-commonmark-0.1.2.tar.gz"
  sha256 "56d518ece5e5d94c1b24943366149e9cb0f6abdb24044c049c6c0ea563d3999e"
  license "LGPL-3.0-or-later"

  depends_on "guile"

  def install
    inreplace "configure", "2.2 2.0", "3.0 2.2 2.0"
    ENV["GUILE_EFFECTIVE_VERSION"] = "3.0"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = share/"guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = lib/"guile/3.0/site-ccache"

    (testpath/"test-commonmark.scm").write <<~SCHEME
      (use-modules (commonmark)
                   (sxml simple))

      (define doc "Hello *World*.")

      ;; Parses the CommonMark.
      (define doc-sxml (commonmark->sxml doc))

      ;; Print to the stdout port
      (sxml->xml doc-sxml)
    SCHEME

    output = shell_output("#{Formula["guile"].bin}/guile --no-auto-compile test-commonmark.scm")
    assert_match "<p>Hello <em>World</em>.</p>", output
  end
end
