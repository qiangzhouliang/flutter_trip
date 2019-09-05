package com.qzl.plugin.asr

import android.util.Log
import io.flutter.plugin.common.MethodChannel


class ResultStateful private constructor(private val result: MethodChannel.Result) : MethodChannel.Result {
    private var called: Boolean = false

    override fun success(o: Any?) {
        if (called) {
            printError()
            return
        }
        called = true
        result.success(o)
    }

    override fun error(s: String, s1: String?, o: Any?) {
        if (called) {
            printError()
            return
        }
        called = true
        result.error(s, s1, o)
    }

    override fun notImplemented() {
        if (called) {
            printError()
            return
        }
        called = true
        result.notImplemented()

    }

    private fun printError() {
        Log.e(TAG, "error:result called")
    }

    companion object {
        private val TAG = "ResultStateful"

        fun of(result: MethodChannel.Result): ResultStateful {
            return ResultStateful(result)
        }
    }
}
