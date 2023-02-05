 import 'dart:developer';
 
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';

import '../decorations.dart';
import '../dimens.dart';
import '../gen/assets.gen.dart';
import '../styles.dart';

class StatesUser {
  static const stateSelectOrigin = 0;
  static const stateSelectDestination = 1;
  static const stateDrivingToTheRigin = 2;
}

class UserSelectOrigin extends StatefulWidget {
  const UserSelectOrigin({Key? key}) : super(key: key);

  @override
  State<UserSelectOrigin> createState() => _UserSelectOriginState();
}

class _UserSelectOriginState extends State<UserSelectOrigin> {
  List<GeoPoint> geoPoints = [];
  List widgetStack = [StatesUser.stateSelectOrigin];
  String destinationAddress = "آدرس مقصد";
  String distance ="در حال محاسبه فاصله";
  Widget markerIcon = SvgPicture.asset(
    Assets.icons.origin,
    height: 100,
    width: 48,
  );

  MapController mapController = MapController(
    initMapWithUserPosition: false,
    initPosition:
        GeoPoint(latitude: 34.34482098636728, longitude: 47.09250897709512),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(
      children: [
        SizedBox.expand(
          child: OSMFlutter(
            controller: mapController,
            trackMyPosition: false,
            //androidHotReloadSupport: true,
            initZoom: 15,
            isPicker: true,

            mapIsLoading: const SpinKitCircle(color: Colors.black),
            minZoomLevel: 8,
            maxZoomLevel: 18,
            showDefaultInfoWindow: true,
            stepZoom: 1.0,
            onMapIsReady: (p0) async {
              // for (var p in socketController.nearDriverList) {
              //   await mapController.addMarker(p,
              //       markerIcon: MarkerIcon(
              //         iconWidget: Image.asset(
              //           Assets.icons.truckOnmap.path,
              //           height: 102,
              //           fit: BoxFit.contain,
              //         ),
              //       ));
              // }
            },
            userLocationMarker: UserLocationMaker(
              personMarker: MarkerIcon(
                iconWidget: SvgPicture.asset(
                  Assets.icons.origin,
                  color: Colors.blue,
                  height: 100,
                  width: 48,
                ),
              ),
              directionArrowMarker: const MarkerIcon(
                icon: Icon(
                  Icons.circle_sharp,
                  size: 48,
                  color: Colors.blue,
                ),
              ),
            ),

            markerOption: MarkerOption(
              advancedPickerMarker: MarkerIcon(iconWidget: markerIcon),
            ),
          ),
        ),
        currentState(),
        Positioned(
            top: 24,
            left: 24,
            child: Container(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(2, 3),
                  blurRadius: 12,
                )
              ], shape: BoxShape.circle, color: Colors.white),
              height: 50,
              width: 50,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    widgetStack.removeLast();
                    mapController.removeMarker(geoPoints.last);
                    if (geoPoints.isEmpty) {
                      mapController.advancedPositionPicker();
                    }

                    if (geoPoints.isNotEmpty) {
                      geoPoints.removeLast();

                      markerIcon = SvgPicture.asset(
                        Assets.icons.origin,
                        height: 100,
                        width: 48,
                      );

                      mapController.init();
                    }
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
            )),
      ],
    )));
  }

  Widget currentState() {
    Widget widget = stateSelectOrigin();

    switch (widgetStack.last) {
      case StatesUser.stateSelectOrigin:
        widget = stateSelectOrigin();
        break;
      case StatesUser.stateSelectDestination:
        widget = stateSelectDestination();
        break;
      case StatesUser.stateDrivingToTheRigin:
        widget = stateDrivingToTheRigin();
        break;
    }

    return widget;
  }

  Widget stateSelectOrigin() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
           decoration: const BoxDecoration(color: Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.all(Dimens.large),
            child: Column(
              children: [



                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        //pick origin

                        geoPoints.add(await mapController
                            .getCurrentPositionAdvancedPositionPicker());
                        //change icon marker
                        markerIcon = SvgPicture.asset(
                          Assets.icons.destination,
                          height: 100,
                          width: 48,
                        );
 
                        setState(()  {
                          widgetStack.add(StatesUser.stateSelectDestination);
                        });

                        mapController.init();

            

                      },
                      child: Text('انتخاب مبدا', style: MyTextStyles.button)),
                ),
                const SizedBox(
                  height: Dimens.medium,
                ),
              ],
            ),
          )),
    );
  }

  Widget stateSelectDestination() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.large),
        child: Column(
          children: [

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
await mapController
                        .getCurrentPositionAdvancedPositionPicker()
                        .then((value) {
                      geoPoints.add(value);
                    });
                    mapController.cancelAdvancedPositionPicker();

                    //mark origin on map
                    await mapController.addMarker(geoPoints[0],
                        markerIcon: MarkerIcon(
                          iconWidget: SvgPicture.asset(
                            Assets.icons.origin,
                            height: 100,
                            width: 48,
                          ),
                        ));

                    //mark origin on map
                    await mapController.addMarker(geoPoints[1],
                        markerIcon: MarkerIcon(
                          iconWidget: SvgPicture.asset(
                            Assets.icons.destination,
                            height: 100,
                            width: 48,
                          ),
                        ));




                     setState(()  {
                      widgetStack.add(StatesUser.stateDrivingToTheRigin);
                    });



                    var d = await distance2point(
                      geoPoints.first,
                      geoPoints.last,
                    );


                     setState(() {
                     if(d<=1000){

                       distance = "فاصله مبدا تا مقصد ${d.toInt()} متر" ;
                    }else if(d>1000){

                      distance = "فاصله مبدا تا مقصد ${d~/1000} کیلومتر";

                    }
                    });
 
                    await getAddress();
                  },
                  child: Text('انتخاب مقصد', style: MyTextStyles.button)),
            ),
          ],
        ),
      ),
    );
  }

  getAddress() async {
    try {
      await placemarkFromCoordinates(
              geoPoints.last.latitude, geoPoints.last.longitude,localeIdentifier: "fa")
          .then((List<Placemark> placemarks) {
        setState(() {
          destinationAddress =
              "${placemarks.first.locality} ${placemarks.first.thoroughfare} ${placemarks[2].name}";
        });
      });
    } catch (e) {
      destinationAddress = "آدرس یافت نشد";
      log(e.toString());
    }
  }

  stateDrivingToTheRigin() {
    mapController.zoomOut();
    mapController.centerMap;
     return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.medium),
        child: Column(
          children: [
            Container(
              height: 58,
              width: double.infinity,
              decoration: MyDecorations.mainCardDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:   [
                  Text(distance.toString()),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.route,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: Dimens.small,
            ),
            Container(
              height: 58,
              width: double.infinity,
              decoration: MyDecorations.mainCardDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    Text(destinationAddress),
                  Container(
                    margin: const EdgeInsets.all(Dimens.medium),
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        border: Border.all(color: Colors.green, width: 3)),
                  ),
                ],
              ),
            ), 
            const SizedBox(
              height: Dimens.small,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {},
                  child: Text('درخواست راننده', style: MyTextStyles.button)),
            ),
          ],
        ),
      ),
    );
  }
 

}
