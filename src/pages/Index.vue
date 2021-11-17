<template>
  <q-page-container>
    <q-page padding>
      <scanner
        @detected="detected"
        :on-detected="detected"
        :reader-size="readerSize"
        :reader-type="'ean_reader'"
      ></scanner>

      <div class="q-pa-md">
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
                  v-model=""
                />
              </q-card-section>
            </q-card>
          </q-expansion-item>

          <q-expansion-item
          expand-separator
          icon="settings"
          label="Select Readers"
        >

            <q-card>
              <q-card-section>
                <q-toggle
                icon="qr_code_scanner"
                  label="Multiple"
                  :false-value="false"
                  :true-value="true"
                  v-model=""
                />
              </q-card-section>
            </q-card>

        </q-expansion-item>
<!--
        <q-expansion-item
          expand-separator
          icon="drafts"
          label="Drafts"
          header-class="text-purple"
        >
          <q-card>
            <q-card-section>
              Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quidem,
              eius reprehenderit eos corrupti commodi magni quaerat ex numquam,
              dolorum officiis modi facere maiores architecto suscipit iste
              eveniet doloribus ullam aliquid.
            </q-card-section>
          </q-card>
        </q-expansion-item>

        <q-expansion-item icon="assessment" label="Disabled" disable>
          <q-card>
            <q-card-section>
              Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quidem,
              eius reprehenderit eos corrupti commodi magni quaerat ex numquam,
              dolorum officiis modi facere maiores architecto suscipit iste
              eveniet doloribus ullam aliquid.
            </q-card-section>
          </q-card>
        </q-expansion-item> -->
        </q-list>
      </div>

      <pre>
  {{ results }}
</pre
      >
    </q-page>
  </q-page-container>
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
  data: () => ({
    readerSize: {
      width: 640,
      height: 480,
    },
    data: null,
    resultcode: "-",
    results: [],
    resultCodeInfo: "-",
    foundCodes: new Map(),
  }),

  methods: {
    detected(payload) {
      console.log(payload.codeResult);
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
