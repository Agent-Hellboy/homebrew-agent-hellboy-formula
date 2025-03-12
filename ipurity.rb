class Ipurity < Formula
  desc "NSFW content detector for iOS devices"
  homepage "https://github.com/Agent-Hellboy/iPurity"
  url "https://github.com/Agent-Hellboy/iPurity/releases/download/v1.0.1/ipurity-v1.0.1.tar.gz"
  sha256 "aa97444b1bcdbeddf670101febcf50ab168c576f6bc4e5ad5f39cdbf41888032"
  license "MIT"

  depends_on "libimobiledevice"
  depends_on "opencv"
  depends_on "pkg-config" => :build  # if needed for ./configure checks

  def install
    # Run the project's configure script
    system "./configure", *std_configure_args

    # Then compile (adjust if your project uses a different build command)
    system "make"

    # install "ipurity".
    bin.install "ipurity"
  end

  test do
    # Simple test: run the binary and check output or exit code
    # Adjust as appropriate for your project
    assert_match "iPurity version", shell_output("#{bin}/ipurity --version")
  end
end
