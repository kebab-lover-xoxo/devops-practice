<script>
  let count = 0;
</script>

<main>
  <h1>Svelte App in Docker</h1>
  <button on:click={() => count += 1}>Clicked {count} times</button>
</main>

<style>
  main {
    font-family: system-ui, sans-serif;
    text-align: center;
    padding: 3rem;
  }

  button {
    font-size: 1rem;
    padding: 0.75rem 1.5rem;
    margin-top: 1rem;
  }
</style>
