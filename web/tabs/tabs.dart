import 'dart:html';
import 'dart:async';
import 'package:web_ui/web_ui.dart';

class Tabs extends WebComponent {
 
  static const String ACTIVE_CLASS = "active";
  List<Element> headers;
    
  void created() {
    super.created();
    init();
  }
  
  void init() {
    headers = this.queryAll("header");
    headers.forEach((header) {
      header.onClick.listen(onClickHandler);
    });
    headers[0].classes.add(ACTIVE_CLASS);
  }
  
  void onClickHandler(MouseEvent e) {
    Element clickedHeader = e.target;
    
    // change the content displayed
    int index = headers.indexOf(clickedHeader);
    ContentElement tabContent = this.shadowRoot.query("#tabContents content"); 
    tabContent.select = 'article:nth-of-type(${index + 1})';
    
    // change the header styling
    headers.forEach((header) {
      header.classes.remove(ACTIVE_CLASS);
    });
    clickedHeader.classes.add(ACTIVE_CLASS);
  }
}
