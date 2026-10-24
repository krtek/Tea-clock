import { track } from '@vercel/analytics'

export function trackStart(tea, degree, time) {
    track('start-tea', { tea, degree, time })
}
