import './style.css'
import quarkusLogo from '/quarkus.svg'
import viteLogo from '/vite.svg'
import { setupCounter } from './counter.js'
import { fetchAffirmation } from './affirmation.js'

document.querySelector('#app').innerHTML = `
  <div>
    <a href="https://docs.quarkiverse.io/quarkus-quinoa/dev/web-frameworks.html" target="_blank">
      <img src="${quarkusLogo}" class="logo vanilla" alt="Quarkus logo" />
    </a>
    <h1 id="affirmation">Get started</h1>
    <div class="card">
      <button id="affirmation-button" type="button">Another Affirmation</button>
    </div>
    <p class="read-the-docs">
      Quinoa is a Quarkus extension which eases the development, the build and serving of single page apps or web components (built with npm : React, Angular, Vue, Lit, Svelte, Astro, SolidJS …) alongside Quarkus. It is possible to use it with a Quarkus backend in a single project.
    </p>
  </div>
`

fetchAffirmation()
