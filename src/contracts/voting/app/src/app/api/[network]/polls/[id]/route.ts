import { NextResponse } from 'next/server';

import { isNetwork } from '@/client';
import { queryPoll } from '@/db';

type RouteParams = {
  network: string;
  id: string;
};

export async function GET(request: Request, context: { params: RouteParams }) {
  try {
    const network = context.params.network;
    if (!isNetwork(network)) {
      return NextResponse.json({ error: 'invalid network' }, { status: 400 });
    }
    const id = parseInt(context.params.id, 10);
    if (!(Number.isInteger(id) && id >= 1)) {
      return NextResponse.json({ error: 'invalid id' }, { status: 400 });
    }
    const poll = await queryPoll(network, id);
    if (poll === null) {
      return NextResponse.json({ error: 'unknown id' }, { status: 400 });
    }
    return NextResponse.json(poll);
  } catch (error) {
    if (error instanceof Error) console.error(error.stack);
    return NextResponse.json({ error: String(error) }, { status: 500 });
  }
}
