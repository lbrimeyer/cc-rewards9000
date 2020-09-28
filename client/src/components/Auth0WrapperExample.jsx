import React from 'react';
import { Auth0Provider } from '@auth0/auth0-react'

const Auth0WrapperExample = ({children}) =>(
  <Auth0Provider
    domain="YOUR_DOMAIN"
    clientId="YOUR_CLIENT_ID"
    redirectUri={window.location.origin}
  >
    {children}
  </Auth0Provider>
)

export default Auth0WrapperExample;
