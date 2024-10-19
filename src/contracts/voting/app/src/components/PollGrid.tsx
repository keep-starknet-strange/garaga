import { useMemo, useState } from "react";
import { Chip } from "@nextui-org/chip";
import { Pagination } from "@nextui-org/pagination";
import { Spinner } from "@nextui-org/spinner";
import { Table, TableHeader, TableColumn, TableBody, TableRow, TableCell, getKeyValue } from "@nextui-org/table";
import useSWR from "swr";
import { useNetwork } from '@starknet-react/core';

import { Network, isNetwork } from '@/client';
import Address from '@/components/Address';
import TallyButton from '@/components/TallyButton';
import ViewResultsButton from '@/components/ViewResultsButton';
import VoteButton from '@/components/VoteButton';
import { Poll } from '@/interfaces';
import { brief, unixTimeISO, unixTimeRelative } from '@/lib';

type Response<T extends object> = {
  count: number;
  previous: string | null;
  next: string | null;
  results: T[];
}

export default function PollGrid() {
  const now = Math.floor(Date.now() / 1000);
  const fetcher = (url: string) => fetch(url).then((res) => res.json());
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(5);
  const { chain } = useNetwork();
  const network = chain.network;
  if (!isNetwork(network)) {
    return <div>Invalid network</div>;
  }
  const { data, isLoading, error } = useSWR<Response<Poll>>(`/api/${network}/polls?offset=${(page - 1) * pageSize}&limit=${pageSize}`, fetcher);
  const pages = useMemo(() => Math.ceil((data?.count ?? 0) / pageSize), [data?.count, pageSize]);
  const loadingState = isLoading ? 'loading' : 'idle';
  if (error || (data && 'error' in data)) return <div>Failed to load polls</div>;

  function renderCell(item: Poll, columnKey: number | string) {
    switch (columnKey) {
    case 'account': return <Address address={item.account}/>;
    case 'time': return <span title={unixTimeISO(item.time)}>{unixTimeRelative(item.time)}</span>
    case 'expirationTime': return <span title={unixTimeISO(item.expirationTime)}>{unixTimeRelative(item.expirationTime)}</span>
    case 'status': return item.expirationTime >= now ? <Chip color="success" variant="faded">Open</Chip> : item.winner === null ? <Chip color="warning" variant="faded">Closed</Chip> : <Chip color="default" variant="faded">Finished</Chip>;
    case 'action': return item.expirationTime >= now ? <VoteButton poll={item}/> : item.winner === null ? <TallyButton poll={item}/> : <ViewResultsButton poll={item}/>;
    default: return getKeyValue(item, columnKey);
    }
  }

  return (
    <Table
      aria-label="Poll list"
      bottomContent={
        pages > 0 ? (
          <Pagination
            isCompact
            showControls
            showShadow
            color="primary"
            page={page}
            total={pages}
            onChange={(page) => setPage(page)}
          />
        ) : null
      }
    >
      <TableHeader>
        <TableColumn key="id">Number</TableColumn>
        <TableColumn key="account">Creator</TableColumn>
        <TableColumn key="question">Question</TableColumn>
        <TableColumn key="time">Start</TableColumn>
        <TableColumn key="expirationTime">End</TableColumn>
        <TableColumn key="status">Status</TableColumn>
        <TableColumn key="voterCount">Votes</TableColumn>
        <TableColumn key="action">Action</TableColumn>
      </TableHeader>
      <TableBody
        items={data?.results ?? []}
        loadingState={loadingState}
        loadingContent={<Spinner />}
      >
        {(item) => (
          <TableRow key={item?.id}>
            {(columnKey) => <TableCell>{renderCell(item, columnKey)}</TableCell>}
          </TableRow>
        )}
      </TableBody>
    </Table>
  );
}
