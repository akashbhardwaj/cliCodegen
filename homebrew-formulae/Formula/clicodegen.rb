# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Clicodegen < Formula
  desc "cliCodegen is demo for parsing deign token from json"
  homepage "https://github.com/akashbhardwaj/cliCodegen"
  url "https://github.com/akashbhardwaj/cliCodegen.git", :tag => "0.1.6"
  head "https://github.com/akashbhardwaj/cliCodegen.git"
  # depends_on "cmake" => :build
  depends_on "swift" => "5.1.0"
  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    # system "./configure", "--disable-debug",
    #                       "--disable-dependency-tracking",
    #                       "--disable-silent-rules",
    #                       "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test cliCodegen`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "#{bin}/codegen" "import Foundation\n"
  end
end
