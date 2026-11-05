# Test case examples

## UI — with Input Data

```ts
import { test, expect } from '../../src/fixtures';
import { products } from '../../src/data/testData';

test('should show the AeroClick Wireless Mouse card when searching AeroClick', { tag: '@smoke' }, async ({ homePage }) => {
  const query = await test.step('Input Data: search term AeroClick', async () => products.aeroClick.search);

  await test.step('Action: open home page and search for the term', async () => {
    await homePage.open();
    await homePage.search(query);
  });

  await test.step('Validation: matching product card is visible', async () => {
    await expect(homePage.productCardByName(products.aeroClick.name)).toBeVisible();
  });
});
```

## UI — no Input Data

```ts
import { test, expect } from '../../src/fixtures';

test('should show a product grid and footer when the home page loads', { tag: '@smoke' }, async ({ homePage }) => {
  await test.step('Action: open the home page', async () => {
    await homePage.open();
  });

  await test.step('Validation: product grid has cards and footer is visible', async () => {
    await expect(homePage.productGrid).toBeVisible();
    await expect(homePage.productCards.first()).toBeVisible();
    await expect(homePage.footer).toBeVisible();
  });
});
```

## API — with Input Data

```ts
import { test, expect } from '../../src/fixtures';
import { env } from '../../src/config/env';

test('should return a token and username when logging in as the demo user', { tag: '@smoke' }, async ({ api }) => {
  const credentials = await test.step('Input Data: demo username and password', async () => ({
    username: env.demoUser,
    password: env.demoPassword,
  }));

  const auth = await test.step('Action: POST /auth/login with demo credentials', async () => {
    return api.auth.login(credentials);
  });

  await test.step('Validation: response includes token and matching username', async () => {
    expect(auth.token).toBeTruthy();
    expect(auth.username).toBe(env.demoUser);
  });
});
```
