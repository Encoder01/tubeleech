import 'package:tubeleech/Pages/settings_page.dart';

/*
class AdmobService{
  static const String testDevice = 'D4B7BFDF5F14F079010CA5E8FBAE87B8';
//  static InterstitialAd _interstitialAd;
  static  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    childDirected: true,
    nonPersonalizedAds: !SettingsPage.personelAds,
  );
  AdmobService(){
    targetingInfo = MobileAdTargetingInfo(
      testDevices: testDevice != null ? <String>[testDevice] : null,
      childDirected: true,
      nonPersonalizedAds: !SettingsPage.personelAds,
    );
  }
  InterstitialAd createInterAd(){
    return InterstitialAd(
      targetingInfo:targetingInfo ,
      adUnitId: getinterstitialAdUnitId(),
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
  }

  static showInterstitial(){
    _interstitialAd ??= AdmobService().createInterAd();
    _interstitialAd
      ..load()..show(anchorOffset: 0.0,horizontalCenterOffset:0,anchorType: AnchorType.bottom);
  }
  static removeInterstitial(){
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
  String getAdMobId(){
    if(Platform.isIOS){
      return 'ca-app-pub-2182756097973140~5680323049';//IOS
    }else if(Platform.isAndroid){
      return 'ca-app-pub-2182756097973140~4698220349';//ANDROİD
    }
    return null;
  }
  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2182756097973140/6602522471';//IOS
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2182756097973140/2072057009';//ANDROİD
    }
    return null;
  }
  String getinterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2182756097973140/8765651389';//IOS
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2182756097973140/9938298101';//ANDROİD
    }
    return null;
  }
  String getNativeAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2182756097973140/2294600044';//IOS
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2182756097973140/1984427099';//ANDROİD
    }
    return null;
  }
}*/