import { defineConfig, devices } from '@playwright/test';

// The CI test job does not run `npm run build`, so the web server builds first.
const origin = 'http://localhost:4321';
const base = '/sdlc-mvt/';

export default defineConfig({
  testDir: 'e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: 0,
  reporter: 'list',
  use: {
    baseURL: origin + base,
    trace: 'retain-on-failure',
  },
  projects: [{ name: 'chromium', use: { ...devices['Desktop Chrome'] } }],
  webServer: {
    command: 'npm run build && npm run preview -- --port 4321 --ignore-lock',
    url: origin + base,
    reuseExistingServer: !process.env.CI,
    timeout: 120_000,
  },
});
