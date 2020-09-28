// vendors
import React from 'react'
import ReactDOM from 'react-dom'

import Auth0WrapperExample from './components/Auth0WrapperExample'
import LoginButton from './components/LoginButton'
import LogoutButton from './components/LogoutButton'

/**
 * Mounting
 */
const App = () => ( 
  <section id="app-root">
    <h1> Mounted </h1>
    <Auth0WrapperExample />
    <LoginButton />
    <LogoutButton />
  </section>
)

ReactDOM.render(<App />, document.getElementById('root'))
