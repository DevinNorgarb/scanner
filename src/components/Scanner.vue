<template>
  <div>
    <div id="interactive" class="viewport scanner">
      <video></video>
      <canvas class="drawingBuffer"></canvas>
    </div>
  </div>
</template>
<script>
import Quagga from "@ericblade/quagga2";

export default {
  name: "Scanner",
  props: {
    onDetected: {
      type: Function
    },
    onProcessed: {
      type: Function
    },
    readerType: {
      type: String,
      default: "code_128_reader"
    },
    readerSize: {
      width: {
        type: Number,
        default: 640
      },
      height: {
        type: Number,
        default: 480
      }
    }
  },
  data() {
    return {
      quaggaState: {
        inputStream: {
          type: "LiveStream",
          constraints: {
            width: { min: this.readerSize.width },
            height: { min: this.readerSize.height },
            facingMode: "environment",
            aspectRatio: { min: 1, max: 2 }
          }
        },
        locator: {
          patchSize: "large",
          halfSample: false
        },
        numOfWorkers: 4,
        frequency: 10,
        decoder: {
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
        },
        locate: true
      }
    };
  },
  mounted() {
    this.init();
  },
  methods: {
    init() {
      Quagga.init(this.quaggaState, function(err) {
        if (err) {
          return console.log(err);
        }
        Quagga.start();
      });

      Quagga.onDetected(this.onDetected ? this.onDetected : this._onDetected);
      Quagga.onProcessed(
        this.onProcessed ? this.onProcessed : this._onProcessed
      );
    },
    reInit() {
      Quagga.stop();

      this.init();
    },
    getImage() {
      const canvas = Quagga.canvas.dom.image;

      return canvas.toDataURL();
    },
    _onProcessed(result) {
      let drawingCtx = Quagga.canvas.ctx.overlay,
        drawingCanvas = Quagga.canvas.dom.overlay;

      if (result) {
        if (result.boxes) {
          drawingCtx.clearRect(
            0,
            0,
            parseInt(drawingCanvas.getAttribute("width")),
            parseInt(drawingCanvas.getAttribute("height"))
          );
          result.boxes
            .filter(function(box) {
              return box !== result.box;
            })
            .forEach(function(box) {
              Quagga.ImageDebug.drawPath(box, { x: 0, y: 1 }, drawingCtx, {
                color: "green",
                lineWidth: 2
              });
            });
        }

        if (result.box) {
          Quagga.ImageDebug.drawPath(result.box, { x: 0, y: 1 }, drawingCtx, {
            color: "#00F",
            lineWidth: 2
          });
        }

        if (result.codeResult && result.codeResult.code) {
          Quagga.ImageDebug.drawPath(
            result.line,
            { x: "x", y: "y" },
            drawingCtx,
            { color: "red", lineWidth: 7 }
          );
        }
      }
    },
    _onDetected(result) {
      console.log("detected: ", result);
      this.$emit("detected", result);
    }
  }
};
</script>
<style lang="css">
/* In order to place the tracking correctly */
canvas.drawing,
canvas.drawingBuffer {
  position: absolute;
  left: 0;
  top: 0;
}
</style>
