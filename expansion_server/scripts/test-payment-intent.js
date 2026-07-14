#!/usr/bin/env node
/** Smoke-test payment-intent on running API. Usage: node scripts/test-payment-intent.js [baseUrl] */
const base = (process.argv[2] || 'http://127.0.0.1:3000/api').replace(/\/$/, '');

async function main() {
  const body = {
    deviceId: `test-${Date.now()}`.slice(0, 32),
    productId: 'com.ryjovs.expansion.remove_ads',
    nick: 'TestPilot',
  };

  const res = await fetch(`${base}/expansion/donations/payment-intent`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
  const text = await res.text();
  console.log('status', res.status);
  console.log(text);

  if (!res.ok) process.exit(1);

  const data = JSON.parse(text);
  if (!data.paymentCode?.startsWith('EXP-')) {
    console.error('missing paymentCode');
    process.exit(1);
  }
  console.log('ok paymentCode=', data.paymentCode);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
