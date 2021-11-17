<template>
  <q-page>
    <h3 style="font-size: 15px q-pa-md">{{ currentCode }}</h3>
    <q-card>
      <q-card-section>
        <scanner
          @detected="detected"
          :on-detected="detected"
          :reader-size="readerSize"
          :reader-type="'ean_reader'"
        ></scanner>
      </q-card-section>
    </q-card>

    <div class="q-pa-md">
      <q-separator spaced />
      <q-item-label header>Configuration</q-item-label>

      <q-list bordered class="rounded-borders">
        <q-expansion-item
          expand-separator
          icon="settings"
          label="Settings"
          caption="Configure the scanner"
        >
          <q-card>
            <q-card-section>
              <q-toggle
                label="Multiple"
                color="pink"
                :false-value="false"
                :true-value="true"
                v-model="multiple"
              />
              <!-- v-model="" -->
            </q-card-section>
          </q-card>
        </q-expansion-item>

        <q-expansion-item
          expand-separator
          icon="qr_code_scanner"
          label="Select Barcode Readers"
        >
          <q-card :key="key" v-for="(reader, key) in readers">
            <q-card-section>
              <q-toggle
                icon="qr_code_scanner"
                :label="reader.name"
                :true-value="true"
                :false-value="false"
                v-model="reader.active"
                :key="key"
                :value="reader.active"
              />
            </q-card-section>
          </q-card>
        </q-expansion-item>
      </q-list>
    </div>
    <pre>
      {{ results }}
    </pre>
  </q-page>
</template>

<script>
import Quagga from "@ericblade/quagga2";

import VueQuagga from "vue-quagga2";
import Scanner from "components/Scanner";
import $ from "jquery";
// import Quagga from "@ericblade/quagga2";
import axios from "axios";

export default {
  components: {
    Scanner,
  },
  mounted() {
    setInterval(() => {

      if (this.countdown > 0) {
        this.countdown--;
      }

      if (this.countdown === 0) {
        this.currentCode = "";
      }

    }, 1000);
  },
  data: () => ({
    readerSize: {
      width: 640,
      height: 480,
    },
    multiple: false,
    readers: [
      {
        name: "code_128_reader",
        id: "code_128_reader",
        active: false
      },
      {
        name: "ean_reader",
        id: "ean_reader",
        active: false
      },
      {
        name: "ean_8_reader",
        id: "ean_8_reader",
        active: false
      },
      {
        name: "code_39_reader",
        id: "code_39_reader",
        active: false
      },
      {
        name: "code_39_vin_reader",
        id: "code_39_vin_reader",
        active: false
      },
      {
        name: "codabar_reader",
        id: "codabar_reader",
        active: false
      },
      {
        name: "upc_reader",
        id: "upc_reader",
        active: false
      },
      {
        name: "upc_e_reader",
        id: "upc_e_reader",
        active: false
      },
      {
        name: "i2of5_reader",
        id: "i2of5_reader",
        active: false
      },
      {
        name: "2of5_reader",
        id: "2of5_reader",
        active: false
      },
      {
        name: "code_93_reader",
        id: "code_93_reader",
        active: false
      },
      {
        name: "code_32_reader",
        id: "code_32_reader",
        active: false
      },
    ],
    activeReaders: [

    ],
    data: null,
    resultcode: "-",
    results: [],
    resultCodeInfo: "-",
    currentCode: "",
    countdown: 0,
  }),

  methods: {
    detected(payload) {
      this.countdown = 10;
      this.currentCode = payload.codeResult.code;

      let exists = this.results.find(
        (code) => code.code == payload.codeResult.code
      );

      if (!exists) {
        this.results.push({ code: payload.codeResult.code });
        console.log(payload, "detecsted");
      }
    },
    logIt(data) {
      // console.log("detected", data);
    },
  },
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
