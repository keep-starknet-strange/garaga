'use client'

import { useParams } from 'next/navigation';

import { title } from "@/components/primitives";
import CreatePollButton from '@/components/CreatePollButton';
import PollGrid from '@/components/PollGrid';
import WalletBar from '@/components/WalletBar';

export default function PollsPage() {
  return (
    <>
      <WalletBar />
      <CreatePollButton />
      <PollGrid />
    </>
  );
}
