<template>
  <div class="scanner_wrapper">
    <button @click="stop">Stop</button>
    <br /><br />
    <span>{{ resultCodeInfo }}</span> <br />
    <span>{{ resultcode }}</span>

    <br />
    <span>{{ foundCodes }}</span>

    <div ref="quagga" class="camera" />
    <pre v-if="data">
      {{ data }}
    </pre>
  </div>
  <!-- <div class="row items-center bg-grey-9" style="height: 100vh">
    <div class="col text-center q-pa-sm ">
      <div id="videoBoundingBox" class="viewport">
    <video autoplay="true" preload="auto"></video>
</div>
      <q-btn
        color="secondary"
        icon="camera_alt"
        label="Scan Parcel"
        class="full-width"
        size="lg"
        @click="startScan()"
        v-show="cameraStatus === 0"
      />
      <div class="text-h6" v-if="code">Tracking Number: {{ code }}</div>
      <div id="scan" v-show="cameraStatus === 1"></div>
    </div>
  </div> -->
</template>

<script>
// import Quagga from "@ericblade/quagga2";
import $ from "jquery";
// export default {
//   name: "Scanner",
//   data() {
//     return {
//       code: "",
//       dialog: false,
//       cameraStatus: 0
//     };
//   },
//   mounted() {
//         var _scannerIsRunning = false;
//             Quagga.init({
//                 inputStream: {
//                     name: "Live",
//                     type: "LiveStream",
//                     target: document.querySelector('#videoBoundingBox'),
//                     constraints: {
//                         width: 480,
//                         height: 320,
//                         facingMode: "environment"
//                     },
//                 },
//                 decoder: {
//                     readers: [
//                         "code_128_reader",
//                         "ean_reader",
//                         "ean_8_reader",
//                         "code_39_reader",
//                         "code_39_vin_reader",
//                         "codabar_reader",
//                         "upc_reader",
//                         "upc_e_reader",
//                         "i2of5_reader"
//                     ],
//                     debug: {
//                         showCanvas: true,
//                         showPatches: true,
//                         showFoundPatches: true,
//                         showSkeleton: true,
//                         showLabels: true,
//                         showPatchLabels: true,
//                         showRemainingPatchLabels: true,
//                         boxFromPatches: {
//                             showTransformed: true,
//                             showTransformedBox: true,
//                             showBB: true
//                         }
//                     }
//                 },

//             }, function (err) {
//                 if (err) {
//                     console.log(err);
//                     return
//                 }

//                 console.log("Initialization finished. Ready to start");
//                 Quagga.start();

//                 // Set flag to is running
//                 _scannerIsRunning = true;
//             });

//             Quagga.onProcessed(function (result) {
//                 var drawingCtx = Quagga.canvas.ctx.overlay,
//                 drawingCanvas = Quagga.canvas.dom.overlay;

//                 if (result) {
//                     if (result.boxes) {
//                         drawingCtx.clearRect(0, 0, parseInt(drawingCanvas.getAttribute("width")), parseInt(drawingCanvas.getAttribute("height")));
//                         result.boxes.filter(function (box) {
//                             return box !== result.box;
//                         }).forEach(function (box) {
//                             Quagga.ImageDebug.drawPath(box, { x: 0, y: 1 }, drawingCtx, { color: "green", lineWidth: 2 });
//                         });
//                     }

//                     if (result.box) {
//                         Quagga.ImageDebug.drawPath(result.box, { x: 0, y: 1 }, drawingCtx, { color: "#00F", lineWidth: 2 });
//                     }

//                     if (result.codeResult && result.codeResult.code) {
//                         Quagga.ImageDebug.drawPath(result.line, { x: 'x', y: 'y' }, drawingCtx, { color: 'red', lineWidth: 3 });
//                     }
//                 }
//             });

//             Quagga.onDetected(function (result) {
//                 console.log("Barcode detected and processed : [" + result.codeResult.code + "]", result);
//             });

//         // Start/stop scanner
//         document.getElementById("btn").addEventListener("click", function () {
//             if (_scannerIsRunning) {
//                 Quagga.stop();
//             } else {
//                 startScanner();
//             }
//         }, false);

//   },
//   methods: {
//     startScan() {
//       return
//       Quagga.init(
//         {
//           inputStream: {
//             name: "Live",
//             type: "LiveStream",
//             target: document.querySelector("#videoBoundingBox")
//           },
//           decoder: {
//             readers: [
//               "code_128_reader",
//               "ean_reader",
//               "ean_8_reader",
//               "code_39_reader",
//               "code_39_vin_reader",
//               "codabar_reader",
//               "upc_reader",
//               "upc_e_reader",
//               "i2of5_reader",
//               "2of5_reader",
//               "code_93_reader",
//               "code_32_reader"
//             ]
//           }
//         },
//         function(err) {
//           if (err) {
//             console.log(err);
//             // setResult(err);
//             err = err.toString();
//             if (err.search("NotFoundError")) {
//               // No camera found. The user is probably in an office environment.
//               // Redirect to previous orders or show a background image of sorts.
//             } else if (err.search("NotAllowedError")) {
//               // The user has blocked the permission request.
//               // We should ask them again just to be sure or redirect them.
//             } else {
//               // Some other error.
//             }

//             return;
//           }
//           // Hide the preview before it's fully initialised.
//           $("#videoBoundingBox").show();
//           // setResult("Initialization finished. Ready to start");
//           console.log("Initialization finished. Ready to start");
//           Quagga.start();

//        Quagga.onDetected(function(result) {
//                 var last_code = result.codeResult.code;
//                     console.log(last_code);
//              });

//           Quagga.onDetected(data => {
//             console.log(data);
//           });
//           // initializeQuaggaFeedback();
//         }
//       );

//       //        cordova.plugins.barcodeScanner.scan(
//       //     function (result) {
//       //         alert("We got a barcode\n" +
//       //               "Result: " + result.text + "\n" +
//       //               "Format: " + result.format + "\n" +
//       //               "Cancelled: " + result.cancelled);
//       //     },
//       //     function (error) {
//       //         alert("Scanning failed: " + error);
//       //     }
//       //  );
//       return;
//       this.cameraStatus = 1;
//     }
//   }
import Quagga from "@ericblade/quagga2";
import axios from "axios";
// };
export default {
  data: () => ({
    data: null,
    resultcode: "-",
    resultCodeInfo: "-",
    foundCodes: new Map()
  }),

  mounted() {
    this.$nextTick(() => {
      Quagga.init(
        {
          inputStream: {
            name: "Live",
            type: "LiveStream",
            target: this.$refs.quagga,
            constraints: {
              width: 640,
              height: 480,
              deviceId: 0,
              facingMode: "environment"
            },
            area: {
              top: "0%",
              right: "0%",
              left: "0%",
              bottom: "0%"
            }
          },
          debug: true,
          locator: {
            halfSample: true,
            patchSize: "medium", // x-small, small, medium, large, x-large
            debug: {
              showCanvas: true,
              showPatches: true,
              showFoundPatches: true,
              showSkeleton: true,
              showLabels: true,
              showPatchLabels: true,
              showRemainingPatchLabels: true,
              boxFromPatches: {
                showTransformed: true,
                showTransformedBox: true,
                showBB: true
              }
            }
          },
          locate: true,
          decoder: {
            // readers: ["ean_reader"]
            readers: [
              "code_128_reader",
              "ean_reader",
              "ean_8_reader",
              "code_39_reader",
              "code_39_vin_reader",
              "codabar_reader",
              "upc_reader",
              "upc_e_reader",
              "i2of5_reader",
              "2of5_reader",
              "code_93_reader",
              "code_32_reader"
            ]
          }
        },
        () => this.start()
      );
    });
  },
  methods: {
    start() {
      Quagga.onDetected(this.onDetected);
      Quagga.start();
      console.log("Quagga started!");
      //this.getCodeInfo('46020480032')
    },
    onDetected(data) {
      this.data = data;
      this.resultcode =
        data.codeResult.code + " - " + data.codeResult.startInfo.error;
      if (this.foundCodes.has(data.codeResult.code)) {
        var val = this.foundCodes.get(data.codeResult.code);
        val++;
        this.foundCodes.set(data.codeResult.code, val);
      } else this.foundCodes.set(data.codeResult.code, 1);
      this.getCodeInfo(data.codeResult.code);
    },
    stop() {
      this.getfoundCodes();
      Quagga.offDetected(this.onDetected);
      Quagga.stop();
      this.$refs.quagga.querySelector("video").remove();
      this.$refs.quagga.querySelector("canvas").remove();
    },
    getCodeInfo(code) {
      var getinfoflag = false;
      for (let [key, value] of this.foundCodes) {
        // get data sorted
        if (value > 10) {
          getinfoflag = true;
        }
      }
      //console.log('getinfoflag='+ getinfoflag + 'resultCodeInfo=' + this.resultCodeInfo);
      if (getinfoflag && this.resultCodeInfo == "-") {
        // console.log("get info...");
        // this.resultCodeInfo = "Поиск: " + code;
        // axios
        //   .get(
        //     `http://barcode-list.ru/barcode/RU/%D0%9F%D0%BE%D0%B8%D1%81%D0%BA.htm?barcode=` +
        //       code
        //   )
        //   .then(response => {
        //     // JSON responses are automatically parsed.
        //     //console.log( response.data );
        //     //var re = '/<h1 class="pageTitle" style="text-align: center ">(.*)</h1>/';
        //     var str = response.data;
        //     var html_start = 'pageTitle" style="text-align: center " >';
        //     var html_end = "</h2>";
        //     var startpos = response.data.indexOf(html_start);
        //     if (startpos != -1) {
        //       console.log("startpos=" + startpos);
        //       var str2 = str.substring(startpos, str.length);
        //       //console.log('zzz='+str2);
        //       var endpos = str2.indexOf(html_end);
        //       var result_str = str2.substring(html_start.length, endpos);
        //       this.resultCodeInfo = result_str;
        //       //console.log( 'result='+result_str);
        //     } else this.resultCodeInfo = "Не найден код: " + code;
        //   })
        //   .catch(e => {
        //     console.log("error=" + e);
        //     //this.errors.push(e)
        //   });
      }
    },
    getfoundCodes() {
      this.foundCodes.forEach(function(value, key, map) {
        console.log("m[" + key + "] = " + value);
      });
    }
  }
};
</script>

<style>
video {
  width: 100%;
  height: auto;
}
/* #scan {
  border-right: 15vh solid orange;
  border-left: 15vh solid orange;
  height: 70vh
} */
/* .verticalLine {
  border-left: thick solid #ff0000;
} */
</style>
