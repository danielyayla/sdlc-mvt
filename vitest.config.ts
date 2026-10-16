import { defineConfig } from 'vitest/config';

// Keep Vitest to unit tests under src/; Playwright owns e2e/.
export default defineConfig({
  test: {
    include: ['src/**/*.test.ts'],
  },
});
