<template>
  <div class="row items-center bg-grey-9" style="height: 100vh">
    <div class="col text-center q-pa-sm ">
      <q-btn color="secondary" icon="camera_alt" label="Scan Parcel"
        class="full-width" size="lg" @click="startScan()"
        v-show="cameraStatus === 0"/>
      <div class="text-h6" v-if="code">Tracking Number: {{ code }}</div>
      <div id="scan" v-show="cameraStatus === 1"></div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Scanner',
  data () {
    return {
      code: '',
      dialog: false,
      cameraStatus: 0
    }
  },
  methods: {
    startScan () {

         cordova.plugins.barcodeScanner.scan(
      function (result) {
          alert("We got a barcode\n" +
                "Result: " + result.text + "\n" +
                "Format: " + result.format + "\n" +
                "Cancelled: " + result.cancelled);
      },
      function (error) {
          alert("Scanning failed: " + error);
      }
   );
return
      this.cameraStatus = 1
    }
  }
}
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
