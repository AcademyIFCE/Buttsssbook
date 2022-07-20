import Vapor

extension ByteBuffer {
    
    func write(to directory: URL) throws -> String {
        var buffer = self
        guard let file = buffer.readData(length: buffer.readableBytes) else {
            throw Abort(.internalServerError)
        }
        let filename = SHA256.hash(data: Data(UUID().uuidString.utf8)).hexEncodedString().prefix(30)
        let path = "images/" + filename + ".png"
        let url = directory.appendingPathComponent(path)
        try file.write(to: url)
        return path
    }
    
}

extension HTTPMediaType {
    
    static func ==(lhs: HTTPMediaType, rhs: [HTTPMediaType]) -> Bool {
        return rhs.contains(lhs)
    }
    
}
