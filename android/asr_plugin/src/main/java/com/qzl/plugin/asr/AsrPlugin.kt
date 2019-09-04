package com.qzl.plugin.asr

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.util.*

/**
 * @author 强周亮(qiangzhouliang)
 * @desc 通过过这个实现flutter和java代码的调运
 * @email 2538096489@qq.com
 * @time 2019/9/3 17:32
 */
class AsrPlugin(registrar: PluginRegistry.Registrar) : MethodChannel.MethodCallHandler {
    private val activity: Activity?
    private var resultStateful: ResultStateful? = null
    private var asrManager: AsrManager? = null
    init {
        this.activity = registrar.activity()
    }
    private val onAsrListener = object : OnAsrListener {
        override fun onAsrReady() {

        }

        override fun onAsrBegin() {

        }

        override fun onAsrEnd() {

        }

        override fun onAsrPartialResult(results: ArrayList<String>, recogResult: RecogResult) {

        }

        override fun onAsrOnlineNluResult(nluResult: String?) {

        }
        //最终的返回结果
        override fun onAsrFinalResult(results: ArrayList<String>, recogResult: RecogResult) {
            if (resultStateful != null) {
                resultStateful?.success(results[0])
            }
        }

        override fun onAsrFinish(recogResult: RecogResult) {

        }

        override fun onAsrFinishError(errorCode: Int, subErrorCode: Int, descMessage: String, recogResult: RecogResult) {
            if (resultStateful != null) {
                resultStateful?.error(descMessage, null, null)
            }
        }

        override fun onAsrLongFinish() {

        }

        override fun onAsrVolume(volumePercent: Int, volume: Int) {

        }

        override fun onAsrAudio(data: ByteArray, offset: Int, length: Int) {

        }

        override fun onAsrExit() {

        }

        override fun onOfflineLoaded() {

        }

        override fun onOfflineUnLoaded() {

        }
    }



    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        initPermission()
        when (methodCall.method) {
            "start" -> {
                resultStateful = ResultStateful.of(result)
                start(methodCall, resultStateful)
            }
            "stop" -> stop(methodCall, result)
            "cancel" -> cancel(methodCall, result)
            else -> result.notImplemented()
        }
    }

    private fun start(call: MethodCall, result: ResultStateful?) {
        if (activity == null) {
            Log.e(TAG, "Ignored start, current activity is null.")
            result?.error("Ignored start, current activity is null.", null, null)
            return
        }
        if (getAsrManager() != null) {
            getAsrManager()?.start(if (call.arguments is Map<*, *>) call.arguments as Map<String, Any> else null)
        } else {
            Log.e(TAG, "Ignored start, current getAsrManager is null.")
            result?.error("Ignored start, current getAsrManager is null.", null, null)
        }
    }

    private fun stop(call: MethodCall, result: MethodChannel.Result) {
        if (asrManager != null) {
            asrManager?.stop()
        }
    }

    private fun cancel(call: MethodCall, result: MethodChannel.Result) {
        if (asrManager != null) {
            asrManager?.cancel()
        }
    }

    private fun getAsrManager(): AsrManager? {
        if (asrManager == null) {
            if (activity != null && !activity.isFinishing) {
                asrManager = AsrManager(activity, onAsrListener)
            }
        }
        return asrManager
    }

    /**
     * android 6.0 以上需要动态申请权限
     */
    private fun initPermission() {
        val permissions = arrayOf(Manifest.permission.RECORD_AUDIO, Manifest.permission.ACCESS_NETWORK_STATE, Manifest.permission.INTERNET, Manifest.permission.READ_PHONE_STATE, Manifest.permission.WRITE_EXTERNAL_STORAGE)

        val toApplyList = ArrayList<String>()

        for (perm in permissions) {
            if (PackageManager.PERMISSION_GRANTED != ContextCompat.checkSelfPermission(activity!!, perm)) {
                toApplyList.add(perm)
                //进入到这里代表没有权限.

            }
        }
        val tmpList = arrayOfNulls<String>(toApplyList.size)
        if (!toApplyList.isEmpty()) {
            ActivityCompat.requestPermissions(activity!!, toApplyList.toTypedArray(), 123)
        }

    }

    companion object {
        private val TAG = "AsrPlugin"

        fun registerWith(registrar: PluginRegistry.Registrar) {
            val channel = MethodChannel(registrar.messenger(), "asr_plugin")
            val instance = AsrPlugin(registrar)
            channel.setMethodCallHandler(instance)
        }
    }
}
