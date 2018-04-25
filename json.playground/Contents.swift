import Foundation

let json = """
{"total":2,"limit":10,"skip":0,"data":[{"body":"This is a female pig.","title":"Ms. Piggy","id":0},{"body":"This is a female pig.","title":"Ms. Piggy","id":1}]}
""".data(using: .utf8)!

struct JSONRoot: Decodable {
	var data:[DataArray]
}

struct DataArray: Decodable {
	let id: Int
	let title: String
	let body: String
}

do {
	let obj = try JSONDecoder().decode(JSONRoot.self, from: json)
	for result in obj.data {
		print("\(result.id) \(result.title)")
	}
} catch {
	print("This is the Error: \(error)")
}
