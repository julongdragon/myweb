import Vapor

final class Routes: RouteCollection {
    let view: ViewRenderer
    init(_ view: ViewRenderer) {
        self.view = view
    }
    
    func build(_ builder: RouteBuilder) throws {
        /// GET /
        builder.get { req in
            return try self.view.make("welcome")
        }
        
        /// GET /hello/...
        builder.resource("hello", HelloController(view))
        
        // response to requests to /info domain
        // with a description of the request
        builder.get("info") { req in
            return req.description
        }
        // CRUD
        
        builder.get("read") { req in
            let read = try Product.all()
            //return try read.makeJSON()
            
            let find = try Product.find(3)
            try find?.delete()
            //find?.item = "PS20"
            //try find?.save()
            //return try find!.makeJSON()
            return try read.makeJSON()
        }
       
        
        builder.post("item","price"){ (req) -> ResponseRepresentable in
            guard let item = req.data["item"]?.string,
                let price = req.data["price"]?.string else {
                    throw Abort.badRequest
            }
            let product = Product(item: item, price: price)
            try product.save()
            return try product.makeJSON()
        }
        
    }
}
