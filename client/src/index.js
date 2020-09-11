// vendors
import React from 'react'
import ReactDOM from 'react-dom'

/**
 * Mounting
 */
const App = () => ( 
  <section id="app-root">
    <h1> Mounted </h1>
  </section>
)

ReactDOM.render(<App />, document.getElementById('root'))
