// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Arrow
import Hummingbird
import Alamofire


func makeRecordBatch() throws -> RecordBatch {
    let doubleBuilder: NumberArrayBuilder<Double> = try ArrowArrayBuilders.loadNumberArrayBuilder()
    doubleBuilder.append(11.11)
    doubleBuilder.append(22.22)
    doubleBuilder.append(33.33)
    doubleBuilder.append(44.44)
    let stringBuilder = try ArrowArrayBuilders.loadStringArrayBuilder()
    stringBuilder.append("test10")
    stringBuilder.append("test22")
    stringBuilder.append("test33")
    stringBuilder.append("test44")
    let date32Builder = try ArrowArrayBuilders.loadDate32ArrayBuilder()
    let date2 = Date(timeIntervalSinceReferenceDate: 86400 * 1)
    let date1 = Date(timeIntervalSinceReferenceDate: 86400 * 5000 + 352)
    date32Builder.append(date1)
    date32Builder.append(date2)
    date32Builder.append(date1)
    date32Builder.append(date2)
    let doubleHolder = ArrowArrayHolderImpl(try doubleBuilder.finish())
    let stringHolder = ArrowArrayHolderImpl(try stringBuilder.finish())
    let date32Holder = ArrowArrayHolderImpl(try date32Builder.finish())
    let result = RecordBatch.Builder()
        .addColumn("col1", arrowArray: doubleHolder)
        .addColumn("col2", arrowArray: stringHolder)
        .addColumn("col3", arrowArray: date32Holder)
        .finish()
    switch result {
    case .success(let recordBatch):
        return recordBatch
    case .failure(let error):
        throw error
    }
}

final class HttpTest {
    var appStarted = false
    var done = false
    var stopFunc: (() -> Void)?
    
    func run() throws {
        _ = Task {
            let router = Router()
            router.get("/") { request, _ -> ByteBuffer in
                let recordBatch = try makeRecordBatch()
                let arrowWriter = ArrowWriter()
                let writerInfo = ArrowWriter.Info(.recordbatch, schema: recordBatch.schema, batches: [recordBatch])
                switch arrowWriter.toStream(writerInfo) {
                case .success(let writeData):
                    return ByteBuffer(data: writeData)
                case.failure(let error):
                    throw error
                }
            }

            // create application using router
            let app = Application(
                router: router,
                configuration: .init(address: .hostname("127.0.0.1", port: 8081))
            )

            try await app.runService()
            return ByteBuffer()
        }
        
        let sem = DispatchSemaphore(value: 0)
        let url = URL(string: "http://127.0.0.1:8081")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer {sem.signal()}
            if let writeData = data {
                let arrowReader = ArrowReader()
                switch arrowReader.fromStream(writeData) {
                case .success(let result):
                    let recordBatches = result.batches
                    print("recordBatch columns: \(recordBatches.count)")
                    let rb = recordBatches[0]
                    print("recordBatch columns: \(rb.columnCount)")
                    for (idx, column) in rb.columns.enumerated() {
                        print("col \(idx)")
                        let array = column.array
                        for idx in 0..<array.length {
                            print("data col \(idx): \(String(describing:array.asAny(idx)))")
                        }
                    }
                case.failure(let error):
                    print("error: \(error)")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }

        task.resume()        
        _ = sem.wait(timeout: .distantFuture)
        print("done running http server")
    }
}

var httpTest = HttpTest()
try httpTest.run()