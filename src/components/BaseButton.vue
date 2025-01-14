<script setup lang="ts">
defineProps(['content'])
</script>
<template>
  <button
    class="px-6 py-2 rounded-lg font-semibold text-white bg-blue-600 hover:bg-blue-700 focus:ring-4 focus:ring-blue-300 dark:bg-blue-500 dark:hover:bg-blue-600 dark:focus:ring-blue-800 transition">
    <slot></slot>
  </button>
</template>
