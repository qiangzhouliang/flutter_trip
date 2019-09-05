package com.qzl.flutter_trip

import android.os.Bundle
import com.qzl.plugin.asr.AsrPlugin
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import org.devio.flutter.splashscreen.SplashScreen


class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    //解决启动白屏的问题
    SplashScreen.show(this,true)
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    //注册自己的插件
    registerSelfPlugin()
  }
  private fun registerSelfPlugin() {
    AsrPlugin.registerWith(registrarFor("com.qzl.plugin.asr.AsrPlugin"))
  }
}
