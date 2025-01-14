<script setup lang="ts">
import { ref } from 'vue';
import axios from 'axios';
const groceries = [{ Name: "Skyr", ActualStock: 4, ExpectedStock: 1 }, { Name: "Broccoli", ActualStock: 1, ExpectedStock: 1 }, { Name: "Mælk", ActualStock: 0, ExpectedStock: 1 }];
const items = ref(groceries.toSorted((a, b) => a.ActualStock - b.ActualStock));
// Reactive variables
var selected = '';
const loading = ref<boolean>(false);
const result = ref<GroceryResponse | null>(null);
const error = ref<string | null>(null);
interface GroceryResponse {
  page_info: object
  offers: Array<Offer>
}
interface Offer {
  name: string
  description: string
  price: number
  images: Array<OfferImage>
  currency_code: string
  business: OfferBusiness
}
interface OfferImage {
  url: string
}
interface OfferBusiness {
  name: string
}
// Function to handle the POST request
const submitGroceryLookup = async (lookup: string) => {
  if (!lookup.trim()) {
    error.value = 'Please enter a grocery name.';
    return;
  }
  selected = lookup;
  loading.value = true;
  error.value = null;

  const apiUrl = 'https://etilbudsavis.dk/api/squid/v4/rpc/get_offers';
  const requestBody = {
    where: {
      term: lookup,
      max_radius: 700000,
      include_upcoming: true,
      business_ids: ['11deC', '267e1m', '71c90', '9ba51', 'd311fg'],
    },
    geohash: 'u1zry95',
    page: {
      page_size: 10,
    },
  };

  try {
    const response = await axios.post(apiUrl, requestBody, { headers: { "x-api-key": import.meta.env.VITE_ETILBUDSAVIS_APIKEY } });
    result.value = response.data;
  } catch (err: any) {
    error.value = err.response?.data?.message || 'An error occurred.';
  } finally {
    loading.value = false;
  }
};
</script>

<template>
  <p class="font-bold text-4xl">Groceries</p>
  <div class="grocery-lookup">
    <div v-for="item in items" class="text-xl my-3">
      <div class="cursor-pointer" v-on:click="submitGroceryLookup(item.Name)">
        {{ item.Name }} - {{ item.ActualStock }} out of {{ item.ExpectedStock }}
      </div>
    </div>

    <div v-if="error">{{ error }}</div>
    <div v-if="result && result.offers.length > 0">

      <h3>Results for {{ selected }}:</h3>
      <div class="flex flex-wrap">
        <div v-for="offer in result.offers" class="p-5">
          <h3 class="font-bold">{{ offer.business.name }}</h3>
          {{ offer.name }} - {{ offer.price }} {{ offer.currency_code }}
          <br />
          <br />
          {{ offer.description }}
          <img :src="offer.images[3].url" />
        </div>
      </div>
    </div>

  </div>
</template>
