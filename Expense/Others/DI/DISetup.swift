//
//  DISetup.swift
//  Expense
//
//  Created by Ray Qu on 14/02/21.
//

import Foundation
class DISetup {
    class func execute() {
        let container = DIContainerImpl.shared;
        registerDataBase(container);
        registerUseCases(container);
        registerRepositories(container);
        registerDataSource(container);
        registerOthers(container);
    }
    
    private class func registerDataBase(_ container : DIContainer) {
        container.register(type: CoreDataPersistence.self) { (_) in
            return CoreDataPersistenceImpl.shared;
        }
    }
    
    private class func registerUseCases(_ container : DIContainer) {
        container.register(type: GetExpenseCategoriesUseCase.self) { (resolver) in
            return GetExpenseCategoriesUseCaseImpl(resolver.resolve(ExpenseCategoryRepository.self)!);
        }
        container.register(type: SaveExpenseCategoryUseCase.self) { (resolver) in
            return SaveExpenseCategoryUseCaseImpl(resolver.resolve(ExpenseCategoryRepository.self)!);
        }
        container.register(type: SaveTransactionUseCase.self) { (resolver) in
            return SaveTransactionUseCaseImp(transactionRepository: resolver.resolve(TransactionRepository.self)!, currencyRepository: resolver.resolve(CurrencyRepository.self)!);
        }
        container.register(type: GetTransactionsUseCase.self) { (resolver) in
            return GetTransactionsUseCaseImpl(transactionRepository: resolver.resolve(TransactionRepository.self)!);
        }
    }
    
    private class func registerRepositories(_ container : DIContainer) {
        container.register(type: ExpenseCategoryRepository.self) { (resolver) in
            return ExpenseCategoryRepositoryImpl(resolver.resolve(ExpenseCategoryLocalDataSource.self)!);
        }
        container.register(type: CurrencyRepository.self) { (resolver) in
            return CurrencyRepositoryImpl(currencyHistoryDataSource: resolver.resolve(CurrencyHistoryRemoteDataSource.self)!);
        }
        container.register(type: TransactionRepository.self) { (resolver) in
            return TransactionRepositoryImpl(localDataSource: resolver.resolve(TransactionLocalDataSource.self)!);
        }
    }
    
    private class func registerDataSource(_ container : DIContainer) {
        container.register(type: CurrencyHistoryRemoteDataSource.self) { (resolver) in
            return CurrencyHistoryRemoteDataSourceImpl(resolver.resolve(HttpApi.self)!);
        }
        container.register(type: TransactionLocalDataSource.self) { (resolver) in
            return TransactionLocalDataSourceImpl(coreDataPersistence: resolver.resolve(CoreDataPersistence.self)!);
        }
        container.register(type: ExpenseCategoryLocalDataSource.self) { (resolver) in
            return ExpenseCategoryLocalDataSourceImpl(coreDataPersistence: resolver.resolve(CoreDataPersistence.self)!);
        }
    }
    
    private class func registerOthers(_ container : DIContainer) {
        container.register(type: HttpApi.self) { (resolver) in
            return HttpApiImpl();
        }
        container.register(type: ExpenseCategorySetup.self) { (resolver) in
            return ExpenseCategorySetupImpl(getExpenseCategoriesUseCase: resolver.resolve(GetExpenseCategoriesUseCase.self)!, saveExpenseCategoryUseCase:resolver.resolve(SaveExpenseCategoryUseCase.self)!);
        }
    }
}
