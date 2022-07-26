import Vapor
import Fluent

extension ByteBuffer {
    
    func write(to directory: URL, contentType: HTTPMediaType?) throws -> String {
        var buffer = self
        guard let file = buffer.readData(length: buffer.readableBytes) else {
            throw Abort(.internalServerError)
        }
        let filename = SHA256.hash(data: Data(UUID().uuidString.utf8)).hexEncodedString().prefix(30)
        let fileExtension = contentType?.description.components(separatedBy: "/").last ?? ""
        let path = "media/" + filename + "." + fileExtension
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

extension URLQueryContainer {
    
    subscript<P, T>(keyPath: KeyPath<P, ParentProperty<P, T>>) -> T.IDValue? {
        let p = P.init()
        let property = p[keyPath: keyPath]
        let name = property.name
        return self[name]
    }
    
}
