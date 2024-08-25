enum MessageEnum{
  text('text');

  const MessageEnum(this.type);
  final String type;


}
extension ConvertMessage on String{
  MessageEnum toEnum(){
    switch(this){
      case 'text':
        return MessageEnum.text;
      default:
        return MessageEnum.text;
        // TODO: Handle this case.
    }
  }
}