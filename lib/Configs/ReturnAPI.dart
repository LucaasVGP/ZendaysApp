class ReturnAPI {
  dynamic Obj;
  late bool Sucesso;
  String? Mensagem;

  ReturnAPI(bool sucesso,String? mensagem,dynamic obj) {
    Sucesso = sucesso;
    Mensagem = mensagem;
    Obj = obj;
  }
}