import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:food_delivery_app/src/controllers/reviews_controller.dart';
import 'package:food_delivery_app/src/elements/CircularLoadingWidget.dart';
import 'package:food_delivery_app/src/models/media.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../models/route_argument.dart';

class ReviewsRestaurantWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  ReviewsRestaurantWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _ReviewsWidgetState createState() {
    return _ReviewsWidgetState();
  }
}

class _ReviewsWidgetState extends StateMVC<ReviewsRestaurantWidget> {
  ReviewsController _con;

  _ReviewsWidgetState() : super(ReviewsController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForRestaurant(id: widget.routeArgument.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        body: _con.restaurant == null
            ? CircularLoadingWidget(height: 500)
            : SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Hero(
                            tag: widget.routeArgument.heroTag + _con.restaurant.id,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: _con.restaurant.image.url,
                              placeholder: (context, url) => Image.asset(
                                'assets/img/loading.gif',
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        width: 110,
                        child: Chip(
                          padding: EdgeInsets.all(10),
                          label: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(_con.restaurant.rate,
                                  style: Theme.of(context).textTheme.headline3.merge(TextStyle(color: Theme.of(context).primaryColor))),
                              Icon(
                                Icons.star_border,
                                color: Theme.of(context).primaryColor,
                                size: 30,
                              ),
                            ],
                          ),
                          backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                          shape: StadiumBorder(),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 30,
                    left: 15,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                _con.restaurant.name,
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(S.of(context).how_would_you_rate_this_restaurant_,
                        textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle1),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _con.restaurantReview.rate = (index + 1).toString();
                            });
                          },
                          child: index < int.parse(_con.restaurantReview.rate)
                              ? Icon(Icons.star, size: 40, color: Color(0xFFFFB24D))
                              : Icon(Icons.star_border, size: 40, color: Color(0xFFFFB24D)),
                        );
                      }),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      onChanged: (text) {
                        _con.restaurantReview.review = text;
                      },
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        hintText: S.of(context).tell_us_about_this_restaurant,
                        hintStyle: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 14)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1))),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1))),
                      ),
                    ),

                    SizedBox(height: 10),
                    TextField(
                      onChanged: (text) {
                        _con.restaurantReview.review = text;
                      },
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        hintText: S.of(context).enter_YouTube_Vimeo_Link,
                        hintStyle: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 14)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1))),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1))),
                      ),
                    ),

                    SizedBox(height: 10),
                    Text(S.of(context).add_media,
                        textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle1),
                    GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, childAspectRatio: 1),
                            shrinkWrap: true,
                            itemCount: _con.images.length < 1 ? _con.images.length + 1 : 1,
                            itemBuilder: (context, index) =>
                            index == _con.images.length
                                ? InkWell(
                                    onTap: () async {
                                      await showDialogForImagePick(context, () async {
                                        var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                                        if (image != null) {
                                          _con.images.add(image);
                                          _con.notifyListeners();
                                          Navigator.pop(context);
                                        }
                                      }, () async {
                                        var image = await ImagePicker.pickVideo(source: ImageSource.gallery);
                                        if (image != null) {
                                          _con.images.add(image);
                                          _con.notifyListeners();
                                          Navigator.pop(context);
                                        }
                                      },() async {
                                        var image = await ImagePicker.pickImage(source: ImageSource.camera);
                                        if (image != null) {
                                          _con.images.add(image);
                                          _con.notifyListeners();
                                          Navigator.pop(context);
                                        }
                                      },() async {
                                        var image = await ImagePicker.pickVideo(source: ImageSource.camera);
                                        if (image != null) {
                                          _con.images.add(image);
                                          _con.notifyListeners();
                                          Navigator.pop(context);
                                        }
                                      },);
                                    },
                                    child: Container(
                                      height: MediaQuery.of(context).size.width / 3,
                                      width: MediaQuery.of(context).size.width / 3,
                                      margin: EdgeInsets.symmetric(horizontal: 5),
                                      alignment: Alignment.center,
                                      child: Icon(Icons.add),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: MediaQuery.of(context).size.width / 3,
                                    width: MediaQuery.of(context).size.width / 3,
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    alignment: Alignment.center,
                                    child: Image.file(
                                      _con.images[index],
                                      fit: BoxFit.cover,
                                      height: MediaQuery.of(context).size.width / 3,
                                      width: MediaQuery.of(context).size.width / 3,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                          ),
                          SizedBox(height: 10),
                    FlatButton.icon(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                      onPressed: () {
                        _con.addOnlyRestaurantReview(_con.restaurantReview);
                        FocusScope.of(context).unfocus();
                      },
                      shape: StadiumBorder(),
                      label: Text(
                        S.of(context).submit,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      icon: Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                      ),
                      textColor: Theme.of(context).primaryColor,
                      color: Theme.of(context).accentColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ));
  }
}

showDialogForImagePick(
    BuildContext context,
    VoidCallback galleryImage,
    VoidCallback galleryVideo,
    VoidCallback cameraImage,
    VoidCallback cameraVideo) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return CupertinoActionSheet(
        title: Wrap(
          spacing: 10,
          alignment: WrapAlignment.center,
          children: <Widget>[
            Icon(Icons.perm_media, color: Colors.orange),
            Text(
              S.of(context).select_media_type,
              style: TextStyle(color: Colors.orange),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: new Text(
              S.of(context).gallery_image,
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            onPressed: galleryImage,
          ),
          FlatButton(
            child: new Text(
              S.of(context).gallery_video,
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            onPressed: galleryVideo,
          ),
          FlatButton(
            child: new Text(
              S.of(context).camera_image,
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            onPressed: cameraImage,
          ),
          FlatButton(
            child: new Text(
              S.of(context).camera_video,
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            onPressed: cameraVideo,
          ),
        ],
      );
    },
  );
}
