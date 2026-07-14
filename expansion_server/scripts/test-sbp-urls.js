#!/usr/bin/env node
const base = 'http://127.0.0.1:3000/api';
const products = [
  'com.ryjovs.expansion.donate_tier1',
  'com.ryjovs.expansion.remove_ads',
  'com.ryjovs.expansion.donate_tier2',
  'com.ryjovs.expansion.donate_tier3',
];

(async () => {
  for (const productId of products) {
    const res = await fetch(`${base}/expansion/donations/payment-intent`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        deviceId: `test-${Date.now()}`.slice(0, 32),
        productId,
        nick: 'Test',
      }),
    });
    const data = await res.json();
    console.log(productId, '->', data.payment?.sbpUrl || '(null)');
  }
})();
