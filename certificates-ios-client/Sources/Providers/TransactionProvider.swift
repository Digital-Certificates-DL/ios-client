//
//  TransactionsRepo.swift
//  certificates-ios-client
//
//  Created by Jonikorjk on 18.05.2023.
//

import Combine
import Foundation

protocol TransactionProviderProtocol: AnyObject {
    var transactionCurrentValueSubject: CurrentValueSubject<Transaction?, Never> { get }
    var transaction: Transaction? { get }
    
    func provideTransactionWithId(txHash: String) async -> Transaction?
}

class TransactionProvider: TransactionProviderProtocol {
    var transactionCurrentValueSubject = CurrentValueSubject<Transaction?, Never>(nil)
    var transaction: Transaction? { transactionCurrentValueSubject.value }
    
    private let transactionApi: TransactionsApiProvider
    
    init(
        transactionApi: TransactionsApiProvider
    ) {
        self.transactionApi = transactionApi
    }
    
    func provideTransactionWithId(txHash: String) async -> Transaction? {
        guard let transactionData = await transactionApi.getTransactionById(txHash) else { return nil }
        do {
            let result = try JSONDecoder().decode(Transaction.self, from: transactionData)
            transactionCurrentValueSubject.send(result)
            return result
        } catch {
            print(error)
        }
        return nil
    }
}
