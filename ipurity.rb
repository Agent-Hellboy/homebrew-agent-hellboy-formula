class Ipurity < Formula
  desc "NSFW content detector for iOS devices"
  homepage "https://github.com/Agent-Hellboy/iPurity"
  url "https://github.com/Agent-Hellboy/iPurity/releases/download/v1.0.1/ipurity-v1.0.1.tar.gz"
  sha256 "aa97444b1bcdbeddf670101febcf50ab168c576f6bc4e5ad5f39cdbf41888032"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "libimobiledevice"
  depends_on "opencv"

  def install
    # Run the project's configure script from the root directory.
    system "./configure", *std_configure_args

    # Create a build directory and run CMake from there.
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end

    # If the CMake install doesn't create versionless symlinks for your library,
    # you can manually create them here. For example:
    # lib.install_symlink "libipurity.dylib.1.0" => "libipurity.dylib"
  end

  test do
    # Simple test: run the binary and check its version output.
    assert_match "iPurity version", shell_output("#{bin}/ipurity --version")
  end
end
