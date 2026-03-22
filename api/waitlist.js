import { Redis } from '@upstash/redis';

const redis = new Redis({
  url: process.env.KV_REST_API_URL,
  token: process.env.KV_REST_API_TOKEN,
});

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const { email } = req.body;

  if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    return res.status(400).json({ error: 'Valid email is required' });
  }

  try {
    const exists = await redis.zscore('waitlist', email);
    if (exists !== null) {
      return res.status(200).json({ success: true, message: 'Already on the list' });
    }

    await redis.zadd('waitlist', { score: Date.now(), member: email });

    return res.status(200).json({ success: true });
  } catch (error) {
    console.error('Redis error:', error);
    return res.status(500).json({ error: 'Something went wrong. Try again.' });
  }
}
