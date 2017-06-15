import Fluent
import PostgreSQLProvider
import FluentProvider

final class Product : Model {
    var storage = Storage()
    var item : String
    var price : String
    init(item:String,price:String){
        self.item = item
        self.price = price
    }
    init(row: Row) throws {
        self.item = try row.get("item")
        self.price = try row.get("price")
    }
}
extension Product : RowRepresentable {
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("item", item)
        try row.set("price", price)
        return row
    }
}
extension Product : Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { (product) in
            product.id()
            product.string("item")
            product.string("price")
        })
    }
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
extension Product : JSONRepresentable {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id?.string)
        try json.set("item", item)
        try json.set("price",price)
        return json
    }
}
