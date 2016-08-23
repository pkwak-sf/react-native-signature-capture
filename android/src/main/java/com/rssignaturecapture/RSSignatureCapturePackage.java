package com.rssignaturecapture;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.JavaScriptModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.uimanager.ViewManager;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import android.app.Activity;
import android.util.Log;

import com.rssignaturecapture.RSSignatureCaptureViewManager;

public class RSSignatureCapturePackage implements ReactPackage {

  public RSSignatureCapturePackage() {
  }

  @Override
  public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
    return Arrays.<NativeModule>asList();
  }

  @Override
  public List<ViewManager> createViewManagers(ReactApplicationContext reactApplicationContext) {
    return Arrays.<ViewManager>asList(new RSSignatureCaptureViewManager());
  }

  @Override
  public List<Class<? extends JavaScriptModule>> createJSModules() {
    return Arrays.asList();
  }

}
