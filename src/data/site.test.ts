import { describe, expect, it } from 'vitest';
import site from './site.json';

const nonEmpty = (value: unknown): value is string =>
  typeof value === 'string' && value.trim().length > 0;

describe('site.json', () => {
  it('has the four copy fields as non-empty strings', () => {
    expect(nonEmpty(site.name)).toBe(true);
    expect(nonEmpty(site.niche)).toBe(true);
    expect(nonEmpty(site.pitch)).toBe(true);
    expect(nonEmpty(site.cta.label)).toBe(true);
  });

  it('uses a mailto: or https: link for the call to action', () => {
    expect(site.cta.href).toMatch(/^(mailto:|https:\/\/)/);
  });
});
