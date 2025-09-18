class ProtocGenGrpcSwiftAT130 < Formula
  desc "Swift gRPC code generator plugin and runtime library"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.3.0.tar.gz"
  sha256 "01e8b3c14f0c3b18fa4b5f18c0f6c46d528f3f73eff2e38049bb0b1e8ad3cc84"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"


  depends_on "swift" => :build
  depends_on "protobuf"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--release", "--product", "protoc-gen-grpc-swift"
    bin.install ".build/release/protoc-gen-grpc-swift"
    doc.install "docs/plugin.md"
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto3";
      package test;
      service Greeter {
        rpc SayHello (HelloRequest) returns (HelloReply) {}
      }
      message HelloRequest { string name = 1; }
      message HelloReply { string message = 1; }
    EOS
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--grpc-swift_out=."
  end
end