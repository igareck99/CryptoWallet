import Foundation

struct TransactionTemplateResponse: Codable {
	let hashes: [TransactionTemplateHash]
	let uuid: String
}

struct TransactionTemplateHash: Codable {
	let index: Int
	let hash: String
}

/*
{
	"hashes": [
		{
		"index": 0,
		"hash": "1851b80fea23f595245cbff303c9581d991c22de5b56370c2e0849be963486b2"
		}
	],
	"uuid": "04d910cf-f65e-4f51-a695-af766b1e1b4d"
}
*/
