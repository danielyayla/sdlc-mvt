import { expect, test } from '@playwright/test';
import site from '../src/data/site.json' with { type: 'json' };

test('the one page serves under the base path with the pitch and a mailto CTA', async ({ page }) => {
  const response = await page.goto('/sdlc-mvt/');
  expect(response?.status()).toBe(200);

  await expect(page.locator('h1')).toHaveCount(1);
  await expect(page.locator('h1')).toHaveText(site.name);
  await expect(page.getByText(site.pitch)).toBeVisible();

  const cta = page.getByRole('link', { name: site.cta.label });
  await expect(cta).toBeVisible();
  expect(await cta.getAttribute('href')).toMatch(/^mailto:/);
});
