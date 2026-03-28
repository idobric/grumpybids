import { Redis } from '@upstash/redis';

const redis = new Redis({
  url: process.env.KV_REST_API_URL,
  token: process.env.KV_REST_API_TOKEN,
});

export default async function handler(req, res) {
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const token = req.headers['x-admin-token'];
  if (!token || token !== process.env.VERCEL_ADMIN_TOKEN) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  try {
    const entries = await redis.zrange('waitlist', 0, -1, { withScores: true });

    const signups = [];
    for (let i = 0; i < entries.length; i += 2) {
      signups.push({
        email: entries[i],
        timestamp: new Date(entries[i + 1]).toISOString(),
      });
    }

    signups.reverse();

    return res.status(200).json({ count: signups.length, signups });
  } catch (error) {
    console.error('Redis error:', error);
    return res.status(500).json({ error: 'Something went wrong.' });
  }
}
