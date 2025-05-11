package com.example.todays_drink

import com.google.android.gms.wearable.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(), DataClient.OnDataChangedListener {


    private val CHANNEL = "com.waithealth/drink"
    private lateinit var dataClient: DataClient
    private val DATA_PATH = "/drink_count"
    private lateinit var methodChannel: MethodChannel
    // flutter ⟷ native 브리지
    override fun configureFlutterEngine(engine: FlutterEngine) {
        super.configureFlutterEngine(engine)
        methodChannel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL)
        

        dataClient = Wearable.getDataClient(this)
        dataClient.addListener(this)              // Wear 수신 리스너

        methodChannel
            .setMethodCallHandler { call, result ->
                if (call.method == "setDrink") {
                    val type    = call.argument<String>("type") ?: "soju"
                    val percent = (call.argument<Double>("percent") ?: 17.0).toFloat()

                    // Wear OS 로 전송
                    val req = PutDataMapRequest.create("/drink_info").apply {
                        dataMap.putString("drink_type", type)
                        dataMap.putFloat ("alcohol_percentage", percent)
                        dataMap.putLong  ("timestamp", System.currentTimeMillis())
                    }.asPutDataRequest()
                    dataClient.putDataItem(req)
                    


                    result.success(null)          // 플러터에 OK 반환
                } else {
                    result.notImplemented()
                }
            }
    }

    // Wear → 폰 데이터 수신 (필요 없으면 비워둠)
    override fun onDataChanged(events: DataEventBuffer) {
        for (ev in events) {
            if (ev.type == DataEvent.TYPE_CHANGED) {
                if (ev.dataItem.uri.path == "/drink_count"){
                    val map = DataMapItem.fromDataItem(ev.dataItem).dataMap
                    val drink = map.getInt("drink_count")
                    val hr = map.getInt("heart_rate")

                    methodChannel.invokeMethod("drinkCount", drink)
                }
                if (ev.dataItem.uri.path == "/bac_info") {
                    val bacF = DataMapItem.fromDataItem(ev.dataItem)
                                      .dataMap.getFloat("bac")

                    methodChannel.invokeMethod("bacUpdate", bacF)    // <-- Flutter 로

                }
            }
        }
    }

    override fun onDestroy() {
        if (::dataClient.isInitialized) dataClient.removeListener(this)
        super.onDestroy()
    }
}
