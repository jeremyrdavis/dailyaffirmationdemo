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
  </div>
`

fetchAffirmation()
