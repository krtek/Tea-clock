import { mount } from 'svelte'
import { inject } from '@vercel/analytics'
import './app.css'
import App from './App.svelte'

inject()

const app = mount(App, {
  target: document.getElementById('app'),
})

export default app
