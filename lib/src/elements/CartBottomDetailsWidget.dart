import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../helpers/helper.dart';

class CartBottomDetailsWidget extends StatefulWidget {
  CartBottomDetailsWidget({
    Key key,
    @required CartController con,
  })  : con = con,
        super(key: key);

  CartController con;
  @override
  CartBottomDetailsWidgetState createState() => CartBottomDetailsWidgetState();
}

class CartBottomDetailsWidgetState extends State<CartBottomDetailsWidget> {
  // Map<String, bool> values = {
  //   'One Meal 10\$': false,
  //   '10% tax': false,
  //   'Round Up': false,
  // };

  List<bool> _data = [false, false, false,false];

  bool isCharitySelected = false;
  String charity = "Select Charity";

  @override
  Widget build(BuildContext context) {

    return widget.con.carts.isEmpty
        ? SizedBox(height: 0)
        : Container(
      height: isCharitySelected ? 315: 275,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                S.of(context).pleaseDonate,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(height: 5),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: charity,
                            hint: Text(
                              S.of(context).charities,
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).accentColor)),
                            ),
                            items: <String>["Select Charity","Charity 1", "Charity 2", "Charity 3", "Charity 4"].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text("$value"),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if(val!="Select Charity") {
                                setState(() {
                                  isCharitySelected = true;
                                  charity = val;
                                });
                              }else{
                                setState(() {
                                  isCharitySelected = false;
                                  charity = val;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      !isCharitySelected ? Container():Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: _buildCheckBoxes(),

                        // child: new ListView.builder(
                        //   itemCount: values.length,
                        //   shrinkWrap: true,
                        //   itemBuilder: (context, index) =>   CheckboxListTile(
                        //     title: new Text(values.keys.toList()[index]),
                        //     value: values.values.toList()[index],
                        //     contentPadding: EdgeInsets.all(0),
                        //     onChanged: (bool val) {
                        //       if(val) {
                        //         setState(() {
                        //           values.update(values.keys.toList()[index], (value) => val);
                        //           widget.con.subTotal +=10;
                        //           final tax = (10 + widget.con.deliveryFee) * widget.con.carts[0].food.restaurant.defaultTax / 100;
                        //           widget.con.subTotal +=tax;
                        //           widget.con.total = widget.con.subTotal + widget.con.taxAmount + widget.con.deliveryFee ;
                        //           widget.con.total = widget.con.total.round().toDouble();
                        //         });
                        //       }else{
                        //         setState(() {
                        //           values.update(values.keys.toList()[index], (value) => val);
                        //           widget.con.subTotal -=10;
                        //           final tax = (10 + widget.con.deliveryFee) * widget.con.carts[0].food.restaurant.defaultTax / 100;
                        //           widget.con.subTotal -=tax;
                        //           widget.con.total = widget.con.subTotal + widget.con.taxAmount + widget.con.deliveryFee;
                        //           widget.con.total = widget.con.total.round().toDouble();
                        //         });
                        //       }
                        //     },
                        //   )
                        // ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
              Container(
                  height: 160,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                      boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)]),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                S.of(context).subtotal,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            Helper.getPrice(widget.con.subTotal, context, style: Theme.of(context).textTheme.subtitle1)
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                S.of(context).delivery_fee,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            if (Helper.canDelivery(widget.con.carts[0].food.restaurant, carts: widget.con.carts))
                              Helper.getPrice(widget.con.carts[0].food.restaurant.deliveryFee, context, style: Theme.of(context).textTheme.subtitle1)
                            else
                              Helper.getPrice(0, context, style: Theme.of(context).textTheme.subtitle1)
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '${S.of(context).tax} (${widget.con.carts[0].food.restaurant.defaultTax}%)',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            Helper.getPrice(widget.con.taxAmount, context, style: Theme.of(context).textTheme.subtitle1)
                          ],
                        ),
                        SizedBox(height: 10),
                        Stack(
                          fit: StackFit.loose,
                          alignment: AlignmentDirectional.centerEnd,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 40,
                              child: FlatButton(
                                onPressed: () {
                                  if(_data.contains(true)){
                                    widget.con.goCheckout(context);
                                  }else{
                                    if(charity != "Select Charity") {
                                      widget.con.scaffoldKey.currentState
                                          ?.showSnackBar(SnackBar(
                                        content: Text(S
                                            .of(context)
                                            .please_select_meal_for_charity),
                                      ));
                                    }else{
                                      widget.con.goCheckout(context);
                                    }
                                  }
                                },
                                disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
                                padding: EdgeInsets.symmetric(vertical: 14),
                                color: !widget.con.carts[0].food.restaurant.closed ? Theme.of(context).accentColor : Theme.of(context).focusColor.withOpacity(0.5),
                                shape: StadiumBorder(),
                                child: Text(
                                  S.of(context).checkout,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColor)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Helper.getPrice(
                                widget.con.total,
                                context,
                                style: Theme.of(context).textTheme.headline4.merge(TextStyle(color: Theme.of(context).primaryColor)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
  }

  Widget _buildCheckBoxes() {
    List<Widget> list = new List();
    Widget cb;

    for (int i=0;i<_data.length;i++) {
      cb = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: _data[i],
            onChanged: (bool value) {
              setState(() {
                _data[i] = value;
                switch(i){
                  case 0: if(value){
                              widget.con.subTotal +=10;
                              final tax = (10 + widget.con.deliveryFee) * widget.con.carts[0].food.restaurant.defaultTax / 100;
                              widget.con.subTotal +=tax;
                              widget.con.total = widget.con.subTotal + widget.con.taxAmount + widget.con.deliveryFee ;
                              widget.con.total = widget.con.total.round().toDouble();
                  }else{
                    widget.con.subTotal -=10;
                    final tax = (10 + widget.con.deliveryFee) * widget.con.carts[0].food.restaurant.defaultTax / 100;
                    widget.con.subTotal -=tax;
                    widget.con.total = widget.con.subTotal + widget.con.taxAmount + widget.con.deliveryFee ;
                    widget.con.total = widget.con.total.round().toDouble();
                  }
                    break;
                  case 1: if(value){
                    final tax = (10 + widget.con.deliveryFee) * widget.con.carts[0].food.restaurant.defaultTax / 100;
                    widget.con.subTotal +=tax;
                    widget.con.total = widget.con.subTotal + widget.con.taxAmount + widget.con.deliveryFee ;
                  }else{
                    final tax = (10 + widget.con.deliveryFee) * widget.con.carts[0].food.restaurant.defaultTax / 100;
                    widget.con.subTotal -=tax;
                    widget.con.total = widget.con.subTotal + widget.con.taxAmount + widget.con.deliveryFee ;
                  }
                  break;
                  case 2: if(value){
                    widget.con.subTotal +=10;
                  }else{
                    widget.con.subTotal -=10;
                  }
                  break;
                  case 3:
                    widget.con.total = widget.con.total.round().toDouble();
                  break;
                }
              });
            },
          ),
          Text(i==0? "One Meal": i==1? "10% Tax": i==2 ? "10\$ +": "Round Up")
        ],
      );
      list.add(cb);
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: list
    );
  }
}
