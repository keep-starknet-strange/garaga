import { NextResponse } from 'next/server';

import { isNetwork } from '@/client';
import { queryPolls } from '@/db';

type RouteParams = {
  network: string;
};

type Response<T extends object> = {
  count: number;
  previous: string | null;
  next: string | null;
  results: T[];
};

export async function GET(request: Request, context: { params: RouteParams }) {
  try {
    const network = context.params.network;
    if (!isNetwork(network)) {
      return NextResponse.json({ error: 'invalid network' }, { status: 400 });
    }
    const url = new URL(request.url);
    const offset = parseInt(url.searchParams.get('offset') ?? '0', 10);
    if (!(Number.isInteger(offset) && offset >= 0)) {
      return NextResponse.json({ error: 'invalid offset' }, { status: 400 });
    }
    const limit = parseInt(url.searchParams.get('limit') ?? '5', 10);
    if (!(Number.isInteger(limit) && 1 <= limit && limit <= 100)) {
      return NextResponse.json({ error: 'invalid limit' }, { status: 400 });
    }
    // TODO implement filtering and ordering
    const { count, polls } = await queryPolls(network, offset, limit);
    url.searchParams.set('offset', String(Math.max(offset - limit, 0)));
    url.searchParams.set('limit', String(limit));
    const previous = url.href;
    url.searchParams.set('offset', String(Math.min(offset + limit, Math.max(count - limit, 0))));
    url.searchParams.set('limit', String(limit));
    const next = url.href;
    const results = polls.slice(0, Math.min(limit, count - offset));
    return NextResponse.json({ count, previous, next, results });
  } catch (error) {
    if (error instanceof Error) console.error(error.stack);
    return NextResponse.json({ error: String(error) }, { status: 500 });
  }
}
