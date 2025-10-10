# typed: false
# frozen_string_literal: true

class Ipurity < Formula
  desc "NSFW content detector for iOS devices"
  homepage "https://github.com/Agent-Hellboy/iPurity"
  url "https://github.com/Agent-Hellboy/iPurity/releases/download/v1.0.6/ipurity-v1.0.6.tar.gz"
  sha256 "d17bfd778999a75465ac9cb73fd37d43f49c36d59ef97258568179e717977a18"
  license "MIT"

  depends_on "cmake" => :bulid
  depends_on "libimobiledevice"
  depends_on "opencv"

  def install
    # Set environment variables for dependencies
    ENV["PKG_CONFIG_PATH"] = "#{Formula["libimobiledevice"].opt_lib}/pkgconfig:#{Formula["opencv"].opt_lib}/pkgconfig"
    ENV["CMAKE_PREFIX_PATH"] = "#{Formula["libimobiledevice"].opt_prefix}:#{Formula["opencv"].opt_prefix}:#{ENV["CMAKE_PREFIX_PATH"]}"

    # Patch the configure script so that the symlink directory is not /opt/homebrew/lib,
    # but instead your formula's lib directory. This allows symlink creation without
    # permission issues.
    inreplace "configure", "/opt/homebrew/lib", lib.to_s

    # Run the project's configure script from the root directory.
    system "./configure", *std_configure_args

    # Create a build directory and run CMake from there.
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
             "-DCMAKE_PREFIX_PATH=#{Formula["libimobiledevice"].opt_prefix}",
             "-DCMAKE_LIBRARY_PATH=#{Formula["libimobiledevice"].opt_lib}",
             "-DCMAKE_INCLUDE_PATH=#{Formula["libimobiledevice"].opt_include}",
             "-DCMAKE_MODULE_PATH=#{Formula["libimobiledevice"].opt_prefix}/lib/cmake",
             "-DLIBIMOBILEDEVICE_ROOT=#{Formula["libimobiledevice"].opt_prefix}",
             "-DLIBIMOBILEDEVICE_LIBRARIES=#{Formula["libimobiledevice"].opt_lib}",
             "-DLIBIMOBILEDEVICE_INCLUDE_DIRS=#{Formula["libimobiledevice"].opt_include}"
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end

    # If needed, you can verify that the symlinks were created in the lib directory:
    # ohai "Symlinked libraries in #{lib}"
  end

  test do
    # Simple test: run the binary and check its version output.
    assert_match "iPurity version", shell_output(bin/"ipurity --version")
  end
end
