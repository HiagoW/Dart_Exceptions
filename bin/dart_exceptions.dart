import 'dart:math';

import 'controllers/bank_controller.dart';
import 'exceptions/bank_controller_exceptions.dart';
import 'models/account.dart';

void testingNullSafety(){
  Account? myAccount;

  //Simulando comunicação externa
  Random rng = Random();
  int randomNumber = rng.nextInt(10);
  if (randomNumber <= 5) {
    myAccount = Account(name: "Richart", balance: 200, isAuthenticated: true);
  }
  
  // Not Safe
  // print(myAccount!.balance);
  
  // if (myAccount != null) {
  //   print(myAccount.balance);
  // } else {
  //   print("Conta nula");
  // }

  // print(myAccount != null ? myAccount.balance : "Conta nula");

  // Print balance only if myAccount not null, else print null
  print(myAccount?.balance);
}

void testingPropertyNullSafety(){
  Account myAccount = Account(name: "Richart", balance: 200, isAuthenticated: true);

  //Simulando comunicação externa
  Random rng = Random();
  int randomNumber = rng.nextInt(10);
  if (randomNumber <= 5) {
    myAccount.createdAt = DateTime.now();
  }

  print(myAccount.createdAt);

  // Does not work. createdAt can be null
  // print(myAccount.createdAt.day);

  // Not safe
  // print(myAccount.createdAt!.day);

  if (myAccount.createdAt != null) {
    // Does not work
    // print(myAccount.createdAt.day);
    print(myAccount.createdAt!.day);
  }
}

void main() {
  testingPropertyNullSafety();

  // Assert
  // Account accountTest = Account(name: "Richart", balance: -20, isAuthenticated: true);

  // Criando o banco
  BankController bankController = BankController();

  // Adicionando contas
  bankController.addAccount(
      id: "Ricarth",
      account:
          Account(name: "Ricarth Lima", balance: 400, isAuthenticated: true));

  bankController.addAccount(
      id: "Kako",
      account:
          Account(name: "Caio Couto", balance: 600, isAuthenticated: true));

  // Fazendo transferência
  try {
    bool result = bankController.makeTransfer(
        idSender: "Kako", idReceiver: "Ricarth", amount: 499);

   if (result) {
     print("Transação concluída com sucesso.");
   }
  } on SenderIdInvalidException catch (e) {
    print(e);
    print("O ID '${e.idSender}' do remetente não é um ID válido.");
  } on ReceiverIdInvalidException catch (e) {
    print(e);
    print("O ID '${e.idReceiver}' do destinatário não é um ID válido.");
  } on SenderNotAuthenticatedException catch (e) {
    print(e);
    print("O usuário remetente de ID '${e.idSender}' não está autenticado.");
  } on SenderBalanceLowerThanAmountException catch (e) {
    print(e);
    print("O usuário de ID '${e.idSender}' tentou enviar ${e.amount} sendo que sua conta tem apenas ${e.senderBalance}.");
  } on Exception {
    print("Algo deu errado.");
  }
}
