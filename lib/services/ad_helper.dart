import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class AdHelper {
  static InterstitialAd? _interstitialAd;

  // ID สำหรับทดสอบ (ห้ามใช้ ID จริงระหว่างพัฒนานะครับ)
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5901161227057601/9045141764'; // ของจริง admob
      // return 'ca-app-pub-3940256099942544/1033173712'; // ตัว test
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // ฟังก์ชันโหลดโฆษณาเตรียมไว้
  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
          _interstitialAd = null;
        },
      ),
    );
  }

  // ฟังก์ชันสั่งแสดงโฆษณา
  static void showInterstitialAd(Function onAdClosed) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitialAd(); // โหลดอันต่อไปรอไว้เลย
          onAdClosed(); // กลับไปทำงานต่อ (เช่น ไปหน้าสรุปคะแนน)
        },
        onAdFailedToShowFullScreenContent: (ad, err) {
          ad.dispose();
          loadInterstitialAd();
          onAdClosed();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      onAdClosed(); // ถ้าโฆษณายังไม่มา ให้ไปหน้าถัดไปเลย ไม่ต้องรอ
    }
  }
}