<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
</script>

<template>
  <header>

    <div class="bg-black">
      <nav>
      </nav>
    </div>
  </header>
  <div class="p-5">
    <RouterView />
  </div>
</template>
