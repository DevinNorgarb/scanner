<template>
  <div>
    <div id="interactive" class="viewport scanner">
      <div class="row items-center " style="height: 70vh">
        <video></video>
        <canvas class="drawingBuffer"></canvas>
        <div class="col text-center q-pa-sm">
          <q-btn
            color="secondary"
            icon="camera_alt"
            label="Scan Parcel"
            class="full-width"
            size="lg"
            @click="reInit()"
          />
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import Quagga from "@ericblade/quagga2";

export default {
  name: "Scanner",
  props: {
    onDetected: {
      type: Function,
    },
    onProcessed: {
      type: Function,
    },
    readers: {
      type: Array,
      default: () => ["ean_reader"],
    },
    multiple: {
      type: Boolean,
      default: () => false,
    },
    readerSize: {
      width: {
        type: Number,
        default: 640,
      },
      height: {
        type: Number,
        default: 480,
      },
    },
  },
  data() {
    return {
      quaggaState: {
        multiple: this.multiple,
        inputStream: {
          type: "LiveStream",
          constraints: {
            width: { min: this.readerSize.width },
            height: { min: this.readerSize.height },
            facingMode: "environment",
            aspectRatio: { min: 1, max: 2 },
          },
        },
        locator: {
          patchSize: "small",
          halfSample: false,
        },
        numOfWorkers: 4,
        frequency: 10,
        decoder: {
          readers: this.readers,
        },
        locate: true,
        lastResult: true,
      },
    };
  },
  mounted() {
    console.log(this.readers);
    this.init();
  },
  methods: {
    init() {
      this.quaggaState.decoder.readers = this.readers;
      Quagga.init(this.quaggaState, (err) => {
        if (err) {
          return console.log(err);
        }
        Quagga.start();
      });

      // Quagga.onDetected();
      Quagga.onProcessed(this._onProcessed);
    },
    reInit() {
      Quagga.stop();

      this.init();
    },
    afterDetected(result) {
      console.log("after detect");
      console.log(result);
      Quagga.stop();
      this.$emit("detected", result);

      // this.onDetected(result);
      // this.reInit();
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
            .filter(function (box) {
              return box !== result.box;
            })
            .forEach(function (box) {
              Quagga.ImageDebug.drawPath(box, { x: 0, y: 1 }, drawingCtx, {
                color: "green",
                lineWidth: 2,
              });
            });
        }

        if (result.box) {
          Quagga.ImageDebug.drawPath(result.box, { x: 0, y: 1 }, drawingCtx, {
            color: "#00F",
            lineWidth: 2,
          });
        }

        if (result.codeResult && result.codeResult.code) {
          Quagga.ImageDebug.drawPath(
            result.line,
            { x: "x", y: "y" },
            drawingCtx,
            { color: "red", lineWidth: 7 }
          );
          this.afterDetected(result);
        }
      }
    },
    _onDetected(result) {
      console.log("detected: ", result);
    },
  },
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
