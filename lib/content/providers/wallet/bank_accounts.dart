import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/requests/bank_account.dart';
import 'package:asset_flutter/content/providers/common/base_provider.dart';
import 'package:asset_flutter/content/providers/wallet/bank_account.dart';
import 'package:asset_flutter/static/routes.dart';

class BankAccountProvider extends BaseProvider<BankAccount>{

  BankAccount findById(String id) {
    return pitems.firstWhere((element) => element.id == id);
  }

  Future<BaseListResponse<BankAccount>> getBankAccounts() async 
    => getList(url: APIRoutes().bankAccRoutes.bankAccsByUserID);

  Future<BaseItemResponse<BankAccount>> addBankAccount(BankAccountCreate bankAccCreate) async 
    => addItem<BankAccountCreate>(bankAccCreate, url: APIRoutes().bankAccRoutes.createBankAcc);
  
  Future<BaseAPIResponse> deleteBankAccount(String id) async 
    =>  deleteItem(id, url: APIRoutes().bankAccRoutes.deleteBankAccByBankAccID, deleteItem: findById(id));
}